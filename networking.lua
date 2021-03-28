require("lib/noobhub")

local cwd = love.filesystem.getSaveDirectory()
local startcmd = ""
local endcmd = ""
if love.system.getOS() == "Windows" then
	cwd = love.filesystem.getWorkingDirectory()
	startcmd = "start /B \"NoobHub Server (DO NOT CLOSE)\" "
	endcmd = " /B"
elseif love.system.getOS() == "OS X" then
	startcmd = "open "
elseif love.system.getOS() == "Linux" then
	startcmd = "xdg-open "
end
local cmd = startcmd.."node \""..cwd.."/YTPPlusCLI/lib/noobhub-server.js\""..endcmd
os.execute(cmd)

-- connect to the server
local hub = noobhub.new({ server = "localhost"; port = 1737; }); 

return { hub = hub }