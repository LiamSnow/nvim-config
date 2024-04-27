import pynvim


@pynvim.plugin
class PyGPT(object):
    nvim: pynvim.Nvim

    def __init__(self, nvim):
        self.nvim = nvim
        self.readConfig()

    def readConfig(self):
        self.config = {
            'height': 10,
        }
        cfg = self.nvim.exec_lua('return require("pygpt").getConfig()')
        self.config.update(cfg)

    @pynvim.command('PyGPTRun', nargs='*', range='')
    def testcommand(self, args, range):
        self.nvim.current.line = (f"{self.config}")
