import anthropic
import pynvim
import datetime
import os
import re

file_extension_to_markdown_map = {
    "py":  "python",
    "rs":  "rust",
    "js":  "javascript",
    "java": "java",
    "c":   "c",
    "cs":  "csharp",
    "cpp": "cpp",
    "go":  "go",
    "php": "php",
    "rb":  "ruby",
    "ts":  "typescript",
    "kt":  "kotlin",
    "m":   "matlab",
    "lua": "lua",
    "sql": "sql",
    "sh":  "bash",
    "html": "html",
    "css": "css",
    "scss": "scss",
    "xml": "xml",
    "json": "json",
    "yml": "yaml",
    "zig": "zig"
}

@pynvim.plugin
class PyGPT(object):
    nvim: pynvim.Nvim

    def __init__(self, nvim):
        self.nvim = nvim
        self.readConfig()
        self.client = anthropic.Anthropic(
            api_key=self.config["anthropic_key"],
        )
        self.initActiveChat()
        self.stream_cancelled = False

    def readConfig(self):
        self.config = {
            "anthropic_key": "",
            "chat_dir": "~/.cache/nvim/pygpt/",
            "default_params": {
                "temperature": 0.2,
                "max_tokens": 1024,
                "system": "",
            }
        }
        cfg = self.nvim.exec_lua('return require("pygpt").getConfig()')
        self.config.update(cfg)

    @pynvim.command("PyGPTNew", nargs='*', range="")
    def new(self, _, range):
        self.setActiveChat(self.makeNewChat())
        self.open(_, range)

    @pynvim.command("PyGPTToggle", nargs='*', range="")
    def toggle(self, _, range):
        current_file = self.nvim.current.buffer.name
        active_chat = self.getActiveChat()

        # already in chat -> go back
        if current_file == active_chat:
            alternate_buffer = self.nvim.funcs.bufnr('#')
            self.nvim.current.buffer = self.nvim.buffers[alternate_buffer]
        # open chat
        else:
            self.open(_, range)

    @pynvim.command("PyGPTOpen", nargs='*', range="")
    def open(self, _, range):
        active_chat = self.getActiveChat()

        # append selection to end of chat
        if (range[0] != range[1]):
            bufnr = self.nvim.current.buffer
            selected_content = "\n".join(bufnr[range[0]-1:range[1]])

            # add markdown code block
            _, file_extension = os.path.splitext(bufnr.name)
            file_extension = file_extension.lstrip('.')
            if file_extension in file_extension_to_markdown_map:
                language = file_extension_to_markdown_map[file_extension]
                selected_content = f"```{language}\n{selected_content}\n```"

            self.openFile(active_chat, f"\n{selected_content}\n")
        # open normally
        else:
            self.openFile(active_chat)

    @pynvim.command("PyGPTRun", nargs='*', range="")
    def run(self, _, range):
        bufnr = self.nvim.current.buffer
        start_line = range[0] - 1
        end_line = range[1]
        selected_content = "\n".join(bufnr[start_line:end_line])

        if (bufnr.name.startswith(self.getChatDir())):
            self.setActiveChat(bufnr.name)

        params = self.readFrontMatter(bufnr)

        try:
            self.stream_cancelled = False
            with self.client.messages.stream(
                max_tokens=params['max_tokens'],
                system=params['system'],
                temperature=params['temperature'],
                messages=[
                    {"role": "user", "content": selected_content}
                ],
                model="claude-3-opus-20240229",
            ) as stream:
                # add blank line
                bufnr.append("", end_line)
                end_line += 1

                # add stream line by line to buffer
                buffer_text = ""
                for text in stream.text_stream:
                    if (self.stream_cancelled):
                        stream.close()
                        break

                    buffer_text += text
                    if "\n" in text:
                        lines = buffer_text.split("\n")
                        for line in lines[:-1]:
                            bufnr.append(line, end_line)
                            end_line += 1
                        buffer_text = lines[-1]
                # append remaining
                if buffer_text:
                    bufnr.append(buffer_text, end_line)
        except anthropic.APIConnectionError as e:
            self.nvim.err_write(f"PyGPT: Anthropic API Connection Error {e.__cause__}\n")
        except anthropic.RateLimitError as e:
            self.nvim.err_write("PyGPT: Anthropic Rate Limit Error\n")
        except anthropic.APIStatusError as e:
            self.nvim.err_write(f"PyGPT: Anthropic Error status={e.status_code} response={e.response}\n")

    @pynvim.command("PyGPTStop")
    def stop(self):
        self.stream_cancelled = True

    @pynvim.command("PyGPTExplorer")
    def explorer(self):
        self.nvim.command(f"Neotree {self.getChatDir()}")

    def readFrontMatter(self, bufnr):
        default = self.config['default_params']

        content = "\n".join(bufnr[:])
        frontmatter_match = re.search(r"^---\n(.*?)\n---", content, re.DOTALL)
        temperature_match = max_tokens_match = system_match = False
        if frontmatter_match:
            frontmatter = frontmatter_match.group(1)
            temperature_match = re.search(r"temperature:\s*(\d+\.?\d*)", frontmatter)
            max_tokens_match = re.search(r"max_tokens:\s*(\d+)", frontmatter)
            system_match = re.search(r"system:\s*(.*)", frontmatter)

        return {
            "temperature": float(temperature_match.group(1)) if temperature_match else default['temperature'],
            "max_tokens": int(max_tokens_match.group(1)) if max_tokens_match else default['max_tokens'],
            "system": system_match.group(1).strip() if system_match else default['system']
        };

    def setActiveChat(self, chat):
        self.nvim.api.set_var("pygpt_active_chat", chat)

    def getActiveChat(self):
        return self.nvim.api.get_var("pygpt_active_chat")

    def getChatDir(self):
        return os.path.expanduser(self.config['chat_dir'])

    def initActiveChat(self):
        chat_dir = self.getChatDir()
        os.makedirs(chat_dir, exist_ok=True)
        last_chat = ""
        chat_files = [f for f in os.listdir(chat_dir) if f.endswith(".md")]
        if chat_files and len(chat_files) > 0:
            most_recent_file = max(chat_files, key=lambda f: os.path.getmtime(os.path.join(chat_dir, f)))
            last_chat = os.path.join(chat_dir, most_recent_file)
        else:
            last_chat = self.makeNewChat()
        self.setActiveChat(last_chat)

    def makeNewChat(self):
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        chat_file = f"{self.getChatDir()}chat_{timestamp}.md"
        os.makedirs(os.path.dirname(chat_file), exist_ok=True)
        with open(chat_file, "w") as file:
            # Add markdown frontmatter
            file.write("---\n")
            for key, value in self.config['default_params'].items():
                file.write(f"{key}: {value}\n")
            file.write("---\n\n\n")
        return chat_file

    def openFile(self, file_path, content=None):
        self.nvim.command(":TSContextDisable")
        if self.nvim.funcs.bufloaded(file_path):
            buf_handle = self.nvim.funcs.bufnr(file_path)
        else:
            buf_handle = self.nvim.funcs.bufadd(file_path)
            self.nvim.funcs.bufload(buf_handle)
        self.nvim.api.set_current_buf(buf_handle)
        self.nvim.api.buf_set_option(buf_handle, "buflisted", True)

        # paste content to bottom
        if content is not None:
            num_lines = len(self.nvim.api.buf_get_lines(buf_handle, 0, -1, True))
            lines = content.split("\n")
            self.nvim.api.buf_set_lines(buf_handle, num_lines, num_lines, True, lines)

        # scroll to bottom of page
        num_lines = len(self.nvim.api.buf_get_lines(buf_handle, 0, -1, True))
        self.nvim.funcs.nvim_win_set_cursor(0, [num_lines, 0])
