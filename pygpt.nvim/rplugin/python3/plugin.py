import pynvim
import datetime
import os
import re
import clients

NOT_CODE_EXTENSIONS = ["md", "txt"]


@pynvim.plugin
class PyGPT(object):
    nvim: pynvim.Nvim

    def __init__(self, nvim):
        self.nvim = nvim
        self.config = self.nvim.exec_lua('return require("pygpt").getConfig()')
        self.stopped = True
        self.stream = None
        self.client = None
        self.initActiveChat()
        self.buffer_count = 0

    @pynvim.command("PyGPTNew", nargs=1, range="")
    def new(self, args, range):
        if len(args) < 1:
            print("Must provide config as argument!")
            return
        self.setActiveChat(self.makeNewChat(args[0]))
        self.open(None, range)

    @pynvim.command("PyGPTToggle", nargs="*", range="")
    def toggle(self, _, range):
        current_file = self.nvim.current.buffer.name
        active_chat = self.getActiveChat()

        # already in chat -> go back
        if current_file == active_chat:
            alternate_buffer = self.nvim.funcs.bufnr("#")
            self.nvim.current.buffer = self.nvim.buffers[alternate_buffer]
        # open chat
        else:
            self.open(_, range)

    @pynvim.command("PyGPTOpen", nargs="*", range="")
    def open(self, _, range):
        active_chat = self.getActiveChat()

        # append selection to end of chat
        if range[0] != range[1]:
            bufnr = self.nvim.current.buffer
            selected_content = "\n".join(bufnr[range[0] - 1 : range[1]])

            # add markdown code block
            _, file_extension = os.path.splitext(bufnr.name)
            file_extension = file_extension.lstrip(".")
            if file_extension not in NOT_CODE_EXTENSIONS:
                selected_content = f"```{file_extension}\n{selected_content}\n```"

            self.openFile(active_chat, f"\n{selected_content}\n")
        # open normally
        else:
            self.openFile(active_chat)

    @pynvim.command("PyGPTRun", nargs="*", range="")
    def run(self, _, range):
        self.stopped = True
        bufnr = self.nvim.current.buffer
        start_line = range[0] - 1
        end_line = range[1]
        selected_content = "\n".join(bufnr[start_line:end_line])
        if bufnr.name.startswith(self.getChatDir()):
            self.setActiveChat(bufnr.name)
        params = self.readFrontMatter(bufnr)
        clients.run(selected_content, end_line, bufnr, params, self)

    @pynvim.command("PyGPTStop")
    def stop(self):
        self.stopped = True

    @pynvim.autocmd('VimLeave', pattern='*', sync=True)
    def on_vim_leave(self):
        self.stopped = True
        if self.stream is not None:
            self.stream.close()
        if self.client is not None:
            self.client.close()

    @pynvim.command("PyGPTExplorer")
    def explorer(self):
        self.nvim.command(f"Neotree {self.getChatDir()}")

    def readFrontMatter(self, bufnr):
        content = "\n".join(bufnr[:])
        frontmatter_match = re.search(r"^---\n(.*?)\n---", content, re.DOTALL)
        config_match = False
        if frontmatter_match:
            temperature_match = max_tokens_match = config_match = None
            frontmatter = frontmatter_match.group(1)
            temperature_match = re.search(r"temperature:\s*(\d+\.?\d*)", frontmatter)
            max_tokens_match = re.search(r"max_tokens:\s*(\d+)", frontmatter)
            config_match = re.search(r"config:\s*(.*)", frontmatter)

            if config_match:
                config_name = config_match.group(1).strip()
                config = self.config["configs"][config_name]
                default_temp = 0.2
                if "temperature" in config:
                    default_temp = config["temperature"]
                return {
                    "temperature": (
                        float(temperature_match.group(1))
                        if temperature_match
                        else default_temp
                    ),
                    "max_tokens": (
                        int(max_tokens_match.group(1))
                        if max_tokens_match
                        else config["max_tokens"]
                    ),
                    "config": config_name,
                }

        if not config_match:
            # use default if there is no frontmatter
            config_name = self.config["default_config"]
            config = self.config["configs"][config_name]
            default_temp = 0.2
            if "temperature" in config:
                default_temp = config["temperature"]
            return {
                "temperature": default_temp,
                "max_tokens": config["max_tokens"],
                "config": config_name,
            }

    def setActiveChat(self, chat):
        self.nvim.api.set_var("pygpt_active_chat", chat)

    def getActiveChat(self):
        return self.nvim.api.get_var("pygpt_active_chat")

    def getChatDir(self):
        return os.path.expanduser(self.config["chat_dir"])

    def initActiveChat(self):
        chat_dir = self.getChatDir()
        os.makedirs(chat_dir, exist_ok=True)
        last_chat = ""
        chat_files = [f for f in os.listdir(chat_dir) if f.endswith(".md")]
        if chat_files and len(chat_files) > 0:
            most_recent_file = max(
                chat_files, key=lambda f: os.path.getmtime(os.path.join(chat_dir, f))
            )
            last_chat = os.path.join(chat_dir, most_recent_file)
        else:
            last_chat = self.makeNewChat()
        self.setActiveChat(last_chat)

    def makeNewChat(self, config_name):
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{self.getChatDir()}{timestamp}.md"
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        with open(filename, "w") as file:
            # Add markdown frontmatter
            file.write("---\n")
            defaults = self.config["configs"][config_name]
            file.write(f"config: {config_name}\n")
            if "temperature" in defaults:
                file.write(f"temperature: {defaults['temperature']}\n")
            file.write(f"max_tokens: {defaults['max_tokens']}\n")
            file.write("---\n\n\n")
        return filename

    def openFile(self, file_path, content=None):
        # self.nvim.command(":TSContextDisable")
        if self.nvim.funcs.bufloaded(file_path):
            buf_handle = self.nvim.funcs.bufnr(file_path)
        else:
            buf_handle = self.nvim.funcs.bufadd(file_path)
            self.nvim.funcs.bufload(buf_handle)
        self.nvim.api.set_current_buf(buf_handle)
        self.nvim.api.buf_set_option(buf_handle, "buflisted", True)
        self.nvim.api.buf_set_var(buf_handle, "pynvim", True)

        # paste content to bottom
        if content is not None:
            num_lines = len(self.nvim.api.buf_get_lines(buf_handle, 0, -1, True))
            lines = content.split("\n")
            self.nvim.api.buf_set_lines(buf_handle, num_lines, num_lines, True, lines)

        # scroll to bottom of page
        num_lines = len(self.nvim.api.buf_get_lines(buf_handle, 0, -1, True))
        self.nvim.funcs.nvim_win_set_cursor(0, [num_lines, 0])
