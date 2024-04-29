import anthropic
import pynvim
import datetime
import os

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

    def readConfig(self):
        self.config = {
            "anthropic_key": "",
            "chat_dir": "~/.cache/nvim/pygpt/",
            "defaults": {
                "temperature": 0.2,
                "token-limit": 1024,
                "system-prompt": "TODO"
            }
        }
        cfg = self.nvim.exec_lua('return require("pygpt").getConfig()')
        self.config.update(cfg)

    @pynvim.command("PyGPTNew")
    def new(self):
        self.setActiveChat(self.makeNewChat())
        self.open(None)

    @pynvim.command("PyGPTOpen")
    def open(self):
        self.openFile(self.getActiveChat())

    @pynvim.command("PyGPTRun", range="")
    def run(self, range):
        bufnr = self.nvim.current.buffer
        self.setActiveChat(bufnr.name)
        start_line = range[0] - 1
        end_line = range[1]
        selected_content = "\n".join(bufnr[start_line:end_line])

        with self.client.messages.stream(
            max_tokens=1024, # TODO
            messages=[
                {"role": "user", "content": selected_content}
            ],
            model="claude-3-opus-20240229",
        ) as stream:
            buffer_text = ""
            for text in stream.text_stream:
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

    @pynvim.command("PyGPTExplorer")
    def explorer(self):
        # TODO dont change dir
        self.nvim.command(f"Neotree {self.config['chat_dir']}")


    def setActiveChat(self, chat):
        self.nvim.api.set_var("pygpt_active_chat", chat)

    def getActiveChat(self):
        return self.nvim.api.get_var("pygpt_active_chat")

    def initActiveChat(self):
        chat_dir = os.path.expanduser(self.config['chat_dir'])
        os.makedirs(chat_dir, exist_ok=True)
        last_chat = ""
        chat_files = [f for f in os.listdir(chat_dir) if f.endswith(".md")]
        if chat_files and chat_files.length > 0:
            most_recent_file = max(chat_files, key=lambda f: os.path.getmtime(os.path.join(chat_dir, f)))
            last_chat = os.path.join(chat_dir, most_recent_file)
        else:
            last_chat = self.makeNewChat()
        self.setActiveChat(last_chat)

    def makeNewChat(self):
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        chat_file = os.path.expanduser(f"{self.config['chat_dir']}/chat_{timestamp}.md")
        os.makedirs(os.path.dirname(chat_file), exist_ok=True)
        open(chat_file, "w").close()
        # TODO inject frontmatter
        return chat_file

    def openFile(self, file_path):
        buf_id = ""
        if (self.nvim.funcs.bufexists(file_path)):
            buf_id = self.nvim.funcs.bufnr(file_path)
        else:
            buf_id = self.nvim.funcs.bufadd(file_path)
        self.nvim.api.set_current_buf(buf_id)
        self.nvim.api.buf_set_option(buf_id, "buflisted", True)
