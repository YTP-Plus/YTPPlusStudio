require("lib/TSerial")
local Enums = require("enums")
local data = {
    Scaling = 2,
    BootType = Enums.BootNormal,
    BackgroundType = Enums.BackgroundNormal,
    LastScreen = Enums.Menu,
    ActiveScreen = Enums.Menu,
    NextScreen = Enums.Menu,
    FadeType = Enums.FadeWhite,
    Volume = 1.0,
    InstantPrompts = false,
    InvertScrollWheel = false,
    Generate = {
        Output = "",
        PluginTestActive = false,
        PluginTest = "",
        Debugging = false,
        TransitionsActive = false,
        Transitions = {},
        MinStream = "0.2",
        MaxStream = "0.4",
        Clips = "20",
        Width = "640",
        Height = "480",
        FPS = "30",
        Sources = {}
    }
}
local info = love.filesystem.getInfo("settings.txt")
if not info then --does not exist
    love.filesystem.write("settings.txt", "{}")
end
local unpack = TSerial.unpack(love.filesystem.read("settings.txt"), true)
for k,v in pairs(unpack) do data[k] = v end --combine data and unpack tables
if data.Scaling < 1 then
    data.Scaling = 1
end
return data
