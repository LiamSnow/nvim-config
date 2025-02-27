local config = {}

local function setup(_config)
    config = _config
end

local function getConfig()
    return config
end

return {setup = setup, getConfig = getConfig}
