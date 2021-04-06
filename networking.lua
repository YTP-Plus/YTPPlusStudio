require("lib/noobhub")

function getPath(str)
    return str:match("(.*[/\\])")
end
local cwd = love.filesystem.getSaveDirectory()
local startcmd = ""
if love.system.getOS() == "Windows" then
	cwd = getPath(love.filesystem.getSource())
	startcmd = "start /B \"\" "
elseif love.system.getOS() == "OS X" then
	--startcmd = "open "
elseif love.system.getOS() == "Linux" then
	--startcmd = "xdg-open "
end
local cmd = "node \""..cwd.."/YTPPlusCLI/lib/noobhub-server.js\""
local path = love.filesystem.getSource()

if not string.find(path, "_nonet.") then
	os.execute(startcmd..cmd)
end

-- connect to the server
local hub = noobhub.new({ server = "localhost"; port = 1737; }); 

return { hub = hub }