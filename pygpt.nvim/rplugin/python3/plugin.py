import anthropic
import pynvim


@pynvim.plugin
class PyGPT(object):
    nvim: pynvim.Nvim

    def __init__(self, nvim):
        self.nvim = nvim
        self.readConfig()
        self.client = anthropic.Anthropic(
            api_key=self.config["anthropic_key"],
        )

    def readConfig(self):
        self.config = {"anthropic_key": "", "openai_key": ""}
        cfg = self.nvim.exec_lua('return require("pygpt").getConfig()')
        self.config.update(cfg)

    @pynvim.command("PyGPTRun", nargs="*", range="")
    def run(self, args, range):
        start_line = range[0] - 1
        end_line = range[1]
        selected_content = "\n".join(self.nvim.current.buffer[start_line:end_line])

        with self.client.messages.stream(
            max_tokens=1024,
            messages=[{"role": "user", "content": selected_content}],
            model="claude-3-opus-20240229",
        ) as stream:
            buffer = self.nvim.current.buffer
            line_num = len(buffer)
            current_line = ""
            for text in stream.text_stream:
                lines = text.split("\n")
                current_line += lines[0]
                if len(lines) > 1:
                    buffer[line_num] += current_line
                    current_line = ""
                    line_num += 1
                    for line in lines[1:-1]:
                        buffer.append(line)
                        line_num += 1
                    current_line = lines[-1]
            if current_line:
                buffer[line_num] += current_line
