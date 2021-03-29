require("lib/noobhub")

local cwd = love.filesystem.getSaveDirectory()
local startcmd = ""
if love.system.getOS() == "Windows" then
	cwd = love.filesystem.getWorkingDirectory()
	startcmd = "start /B \"\" "
elseif love.system.getOS() == "OS X" then
	--startcmd = "open "
elseif love.system.getOS() == "Linux" then
	--startcmd = "xdg-open "
end
local cmd = "node \""..cwd.."/YTPPlusCLI/lib/noobhub-server.js\""
os.execute(startcmd..cmd)

-- connect to the server
local hub = noobhub.new({ server = "localhost"; port = 1737; }); 

return { hub = hub }