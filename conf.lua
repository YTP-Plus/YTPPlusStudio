function love.conf(t)
    love.filesystem.setIdentity("ytpplusstudio_1")
    local Enums = require("enums") --conf enums
    local Data = require("data")
    local ver = Data.Version.Major.."."..Data.Version.Minor.."."..Data.Version.Patch
    if Data.Version.Label ~= nil then ver = ver.."-"..Data.Version.Label.."."..Data.Version.Candidate end
    local path = love.filesystem.getSource()
    local cli = ""
    love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")
    local info = love.filesystem.getInfo("YTPPlusCLI")
	if info then --does not exist
        cli = "[cli v"..love.filesystem.read("YTPPlusCLI/version.txt").."]"
    end
    if string.find(path, ".love") or string.find(path, ".exe") then
        t.window.title = "ytp+ studio [v"..ver.."] "..cli
    else
        t.window.title = "ytp+ studio "..cli
    end
    t.window.width = Enums.Width
    t.window.height = Enums.Height
    t.window.icon = "logo.png"
    t.console = true
end
