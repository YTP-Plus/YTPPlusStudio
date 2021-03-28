function love.conf(t)
    local Enums = require("enums") --conf enums
    local ver = Enums.Version.Major.."."..Enums.Version.Minor.."."..Enums.Version.Patch
    if Enums.Version.Label ~= nil then ver = ver.."-"..Enums.Version.Label.."."..Enums.Version.Candidate end
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
    love.filesystem.setIdentity("ytpplusstudio_"..Enums.Version.Major)
    t.window.width = Enums.Width
    t.window.height = Enums.Height
    t.window.icon = "logo.png"
    t.console = true
end
