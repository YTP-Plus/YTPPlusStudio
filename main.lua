function love.load()
	utf8 = require("utf8")
	Audio = require("audio")
	Graphics = require("gfx")
	Enums = require("enums")
	Data = require("data")
	Canvas = love.graphics.newCanvas(Enums.Width,Enums.Height)
	Canvas:setFilter("nearest", "nearest")
	Main = {
		Cursor = 0,
		TransitionCursor = 0,
		Boot = 0,
		LastScreen = Data.LastScreen,
		ActiveScreen = Data.ActiveScreen,
		NextScreen = Data.NextScreen,
		Fade = Enums.FadeNone,
		ScreenWait = 0,
		W = 0,
		X = 0,
		Y = 0,
		Flip = 0,
		Flipping = false,
		Prompt = nil,
		OldTextBuffer = "",
		TextEntry = "",
		TextNum = false,
		Hovering = {}
	}
	love.window.setMode( Enums.Width*Data.Scaling, Enums.Height*Data.Scaling, Enums.WindowFlags )
	love.mouse.setCursor( Graphics.Cursor )
	if Data.BootType < Enums.BootNoAudio then
		Audio.Boot:play()
	elseif Data.BootType >= Enums.BootNone then
		Main.Boot = 1
	end
	love.audio.setVolume(Data.Volume)
	love.keyboard.setKeyRepeat(true)
	love.filesystem.mount(love.filesystem.getSourceBaseDirectory(), "")
	Save()
end
function love.draw()
	love.graphics.setCanvas(Canvas) --This sets the draw target to the canvas
	love.graphics.clear()
	if Data.BackgroundType < Enums.BackgroundBlack then
		love.graphics.setBackgroundColor(0.25,0.25,0.25,Main.Boot) --#404040
	end
	--tiled background
	if Data.BackgroundType < Enums.BackgroundNone then
		love.graphics.setColor(0.4,0.4,0.4)
		love.graphics.draw(Graphics.Tiles, Graphics.TiledQuad, Main.X - Enums.BackgroundSize, Main.Y - Enums.BackgroundSize) --bottom left corner
		love.graphics.draw(Graphics.Tiles, Graphics.TiledQuad, Main.X + Enums.BackgroundSize, Main.Y + Enums.BackgroundSize) --top right corner
		love.graphics.draw(Graphics.Tiles, Graphics.TiledQuad, Main.X + Enums.BackgroundSize, Main.Y - Enums.BackgroundSize) --bottom left corner
		love.graphics.draw(Graphics.Tiles, Graphics.TiledQuad, Main.X - Enums.BackgroundSize, Main.Y + Enums.BackgroundSize) --top left corner
	end
	--end bg
	love.graphics.setColor(0,0,0,Main.Boot)
	love.graphics.rectangle("fill",2,2,Enums.Width-4,17) --title bar
	--these are all parameters for the border around the screen:
	love.graphics.setColor(0.5,0.5,0.5,Main.Boot)
	love.graphics.rectangle("fill",0,0,2,Enums.Height)
	love.graphics.rectangle("fill",Enums.Width-2,0,2,Enums.Height)
	love.graphics.rectangle("fill",1,0,Enums.Width-2,2)
	love.graphics.rectangle("fill",1,Enums.Height-2,Enums.Width-2,2)
	--end border
	--back button
	love.graphics.setColor(0.5,0.5,0.5,Main.Boot)
	love.graphics.rectangle("fill",2,2,17,17)
	love.graphics.setColor(1,1,1,Main.Boot)
	love.graphics.draw(Graphics.Back,2,2)
	--end back button
	if Main.ActiveScreen ~= Enums.Menu then
		--header
		love.graphics.setColor(1,1,1) --#FFFFFF
		love.graphics.setFont(Graphics.Munro.Regular)
		love.graphics.printf(Enums.ScreenNames[Main.ActiveScreen], 0, 6-3, Enums.Width, "center")
		--draw screen types
		if Main.ActiveScreen == Enums.Generate then
			--mid divider
			love.graphics.setColor(0.5,0.5,0.5)
			love.graphics.rectangle("fill",159,128,2,108)
			--render button
			love.graphics.rectangle("fill",248,2,70,17)
			--shadows left
			love.graphics.setColor(0,0,0)
			love.graphics.print("output debugging info:",9,148-2)
			love.graphics.print("minimum stream duration:",9,165-2)
			love.graphics.print("maximum stream duration:",9,182-2)
			love.graphics.print("clip count:",9,199-2)
			love.graphics.print("resolution:",9,216-2)
			love.graphics.print("x",84,216-2)
			--shadows right
			love.graphics.print("fps:",168,165-2)
			--white color
			love.graphics.setColor(1,1,1)
			love.graphics.draw(Graphics.Generate.ImportBG,4,21)
			love.graphics.draw(Graphics.Generate.Up,4,112)
			love.graphics.draw(Graphics.Generate.Down,17,112)
			love.graphics.print("render and open",250,6-3)
			love.graphics.print((Main.Cursor+1).."-"..(Main.Cursor+6).."/"..#Data.Generate.Sources,30,115-3)
			if #Data.Generate.Sources < 1 then
				love.graphics.printf("(no sources, import video files)", 0, 115-3, Enums.Width, "center")
			else
				love.graphics.printf("clear", 0, 115-3, Enums.Width, "center")
			end
			--dividers
			love.graphics.draw(Graphics.Generate.Dividers.Output,43,142)
			love.graphics.draw(Graphics.Generate.Dividers.PluginTest,218,142)
			--left buttons
			love.graphics.draw(Graphics.Generate.Buttons.Output,4,128)
			love.graphics.draw(Graphics.Generate.Buttons.Checkbox,102,145) --debugging
			love.graphics.draw(Graphics.Generate.Buttons.InputField,120,162) --min stream
			love.graphics.draw(Graphics.Generate.Buttons.InputField,124,179) --max stream
			love.graphics.draw(Graphics.Generate.Buttons.InputField,50,196) --clip count
			love.graphics.draw(Graphics.Generate.Buttons.InputField,52,213) --res width
			love.graphics.draw(Graphics.Generate.Buttons.InputField,90,213) --res height
			love.graphics.print("output:",8,131-3)
			love.graphics.print("output debugging info:",8,148-3)
			love.graphics.print("minimum stream duration:",8,165-3)
			love.graphics.print("maximum stream duration:",8,182-3)
			love.graphics.print("clip count:",8,199-3)
			love.graphics.print("resolution:",8,216-3)
			love.graphics.print("x",83,216-3)
			--right buttons
			love.graphics.draw(Graphics.Generate.Buttons.PluginTest,163,128)
			love.graphics.draw(Graphics.Generate.Buttons.Transitions,163,145)
			love.graphics.draw(Graphics.Generate.Buttons.Checkbox,301,128) --toggle plugin test
			love.graphics.draw(Graphics.Generate.Buttons.Checkbox,218,145) --toggle transitions
			love.graphics.draw(Graphics.Generate.Buttons.InputField,182,162) --fps
			love.graphics.print("plugin test:",167,131-3)
			love.graphics.print("transitions:",167,148-3)
			love.graphics.print("fps:",167,165-3)
			--imports
			if #Data.Generate.Sources >= 1 and Main.Cursor < #Data.Generate.Sources then
				love.graphics.print(Data.Generate.Sources[Main.Cursor+1],8,25-3)
				love.graphics.draw(Graphics.Generate.Remove,301,21)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,36)
			end
			if #Data.Generate.Sources >= 2 and Main.Cursor+1 < #Data.Generate.Sources then
				love.graphics.print(Data.Generate.Sources[Main.Cursor+2],8,40-3)
				love.graphics.draw(Graphics.Generate.Remove,301,36)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,51)
			end
			if #Data.Generate.Sources >= 3 and Main.Cursor+2 < #Data.Generate.Sources then
				love.graphics.print(Data.Generate.Sources[Main.Cursor+3],8,55-3)
				love.graphics.draw(Graphics.Generate.Remove,301,51)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,66)
			end
			if #Data.Generate.Sources >= 4 and Main.Cursor+3 < #Data.Generate.Sources then
				love.graphics.print(Data.Generate.Sources[Main.Cursor+4],8,70-3)
				love.graphics.draw(Graphics.Generate.Remove,301,66)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,81)
			end
			if #Data.Generate.Sources >= 5 and Main.Cursor+4 < #Data.Generate.Sources then
				love.graphics.print(Data.Generate.Sources[Main.Cursor+5],8,85-3)
				love.graphics.draw(Graphics.Generate.Remove,301,81)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,96)
			end
			if #Data.Generate.Sources >= 6 and Main.Cursor+5 < #Data.Generate.Sources then
				love.graphics.print(Data.Generate.Sources[Main.Cursor+6],8,100-3)
				love.graphics.draw(Graphics.Generate.Remove,301,96)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,111)
			end
			--modifier shadows
			love.graphics.setColor(0,0,0)
			love.graphics.print(Data.Generate.Output,44,131-2)
			love.graphics.print(Data.Generate.PluginTest,219,131-2)
			--modifiers
			love.graphics.setColor(1,1,1)
			love.graphics.print(Data.Generate.Output,43,131-3)
			love.graphics.print(Data.Generate.PluginTest,218,131-3)
			love.graphics.print(Data.Generate.MinStream,124,166-3)
			love.graphics.print(Data.Generate.MaxStream,128,183-3)
			love.graphics.print(Data.Generate.Clips,54,200-3)
			love.graphics.print(Data.Generate.Width,56,217-3)
			love.graphics.print(Data.Generate.Height,94,217-3)
			love.graphics.print(Data.Generate.FPS,186,166-3)
			--checkmarks
			if Data.Generate.Debugging then
				love.graphics.print("x",107,148-3)
			end
			if Data.Generate.PluginTestActive then
				love.graphics.print("x",306,131-3)
			end
			if Data.Generate.TransitionsActive then
				love.graphics.print("x",223,148-3)
			end
		elseif Main.ActiveScreen >= Enums.LastScreen and Main.ActiveScreen < Enums.TotalScreens+1 and Data.Generate[Main.TextEntry] ~= nil then --text entry screens
			love.graphics.setColor(0.5,0.5,0.5)
			love.graphics.rectangle("fill",294,2,24,17)
			love.graphics.setColor(1,1,1)
			love.graphics.print("enter",296,6-3)
			love.graphics.draw(Graphics.Generate.Dividers.Import,8,127)
			love.graphics.printf(Main.OldTextBuffer, 0, 116-3, Enums.Width, "center")
		elseif Main.ActiveScreen == Enums.Transitions then
			love.graphics.setColor(1,1,1)
			love.graphics.draw(Graphics.Transitions.TransitionsBG,4,21)
			love.graphics.draw(Graphics.Generate.Up,4,222)
			love.graphics.draw(Graphics.Generate.Down,17,222)
			love.graphics.print((Main.TransitionCursor+1).."-"..(Main.TransitionCursor+13).."/"..#Data.Generate.Transitions,30,225-3)
			if #Data.Generate.Transitions < 1 then
				love.graphics.printf("(no transitions, import video files)", 0, 225-3, Enums.Width, "center")
			else
				love.graphics.printf("clear", 0, 224-3, Enums.Width, "center")
			end
			--imports
			if #Data.Generate.Transitions >= 1 and Main.TransitionCursor < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+1],8,25-3)
				love.graphics.draw(Graphics.Generate.Remove,301,21)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,36)
			end
			if #Data.Generate.Transitions >= 2 and Main.TransitionCursor+1 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+2],8,40-3)
				love.graphics.draw(Graphics.Generate.Remove,301,36)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,51)
			end
			if #Data.Generate.Transitions >= 3 and Main.TransitionCursor+2 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+3],8,55-3)
				love.graphics.draw(Graphics.Generate.Remove,301,51)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,66)
			end
			if #Data.Generate.Transitions >= 4 and Main.TransitionCursor+3 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+4],8,70-3)
				love.graphics.draw(Graphics.Generate.Remove,301,66)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,81)
			end
			if #Data.Generate.Transitions >= 5 and Main.TransitionCursor+4 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+5],8,85-3)
				love.graphics.draw(Graphics.Generate.Remove,301,81)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,96)
			end
			if #Data.Generate.Transitions >= 6 and Main.TransitionCursor+5 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+6],8,100-3)
				love.graphics.draw(Graphics.Generate.Remove,301,96)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,111)
			end
			if #Data.Generate.Transitions >= 7 and Main.TransitionCursor+6 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+7],8,115-3)
				love.graphics.draw(Graphics.Generate.Remove,301,111)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,126)
			end
			if #Data.Generate.Transitions >= 8 and Main.TransitionCursor+7 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+8],8,130-3)
				love.graphics.draw(Graphics.Generate.Remove,301,126)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,141)
			end
			if #Data.Generate.Transitions >= 9 and Main.TransitionCursor+8 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+9],8,145-3)
				love.graphics.draw(Graphics.Generate.Remove,301,141)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,156)
			end
			if #Data.Generate.Transitions >= 10 and Main.TransitionCursor+9 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+10],8,160-3)
				love.graphics.draw(Graphics.Generate.Remove,301,156)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,171)
			end
			if #Data.Generate.Transitions >= 11 and Main.TransitionCursor+10 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+11],8,175-3)
				love.graphics.draw(Graphics.Generate.Remove,301,171)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,186)
			end
			if #Data.Generate.Transitions >= 12 and Main.TransitionCursor+11 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+12],8,190-3)
				love.graphics.draw(Graphics.Generate.Remove,301,186)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,201)
			end
			if #Data.Generate.Transitions >= 13 and Main.TransitionCursor+12 < #Data.Generate.Transitions then
				love.graphics.print(Data.Generate.Transitions[Main.TransitionCursor+13],8,205-3)
				love.graphics.draw(Graphics.Generate.Remove,301,201)
				love.graphics.draw(Graphics.Generate.Dividers.Import,8,216)
			end
		end
	else --menu
		--header
		love.graphics.setColor(1,1,1,Main.Boot) --white with boot sequence as its transparency
		love.graphics.draw(Graphics.Icon, 129+Graphics.Icon:getWidth()/2,4+Graphics.Icon:getHeight()/2, Main.Flip, 1, 1, Graphics.Icon:getWidth()/2, Graphics.Icon:getHeight()/2) --this icon is positioned by its center and rotates that way
		love.graphics.setFont(Graphics.Munro.Regular)
		love.graphics.print("ytp+ studio",146,6-3) --minus 3 due to font scaling
		--buttons
		love.graphics.setColor(0,0,0,Main.Boot)
		love.graphics.print("generate\n\nplugins (not yet available)\n\noptions\n\nquit",23,90-3) --shadow
		love.graphics.setColor(1,1,1,Main.Boot)
		love.graphics.print("generate\n\nplugins (not yet available)\n\noptions\n\nquit",22,89-3) --main menu, not centered, \n means new line
	end
	--fading
	local color = 1
	local fadet = Main.ScreenWait
	if Data.FadeType == Enums.FadeBlack then
		color = 0
	elseif Data.FadeType >= Enums.FadeNone then
		Main.ScreenWait = 1 --stop the timer
		fadet = 0
	end
	love.graphics.setColor(color,color,color,fadet)
	love.graphics.rectangle("fill",0,0,Enums.Width,Enums.Height)
	--color tint, commented for later functionality
	--[[
	love.graphics.setColor(1,0,1,0.1) --pinkish?
	love.graphics.rectangle("fill",0,0,Enums.Width,Enums.Height)
	]]
	--prompts
	if Main.Prompt ~= nil then
		love.graphics.setColor(0,0,0,0.5)
		love.graphics.rectangle("fill",0,0,Enums.Width,Enums.Height)
		love.graphics.setColor(1,1,1)
		love.graphics.draw(Graphics.Prompt,46+Graphics.Prompt:getWidth()/2,Main.Prompt.Y+Graphics.Prompt:getWidth()/2, 0, 1, 1, Graphics.Prompt:getWidth()/2, Graphics.Prompt:getHeight()/2)
		if Main.Prompt.Choice1 ~= "" then
			love.graphics.draw(Graphics.Choice,50+Graphics.Choice:getWidth()/2,Main.Prompt.Y+135+Graphics.Choice:getHeight()/2, 0, 1, 1, Graphics.Choice:getWidth()/2, Graphics.Choice:getHeight()/2)
		end
		love.graphics.setColor(1,1,1)
		--description
		love.graphics.printf(Main.Prompt.Line1, 0, Main.Prompt.Y+66-3, Enums.Width, "center")
		love.graphics.printf(Main.Prompt.Line2, 0, Main.Prompt.Y+78-3, Enums.Width, "center")
		love.graphics.printf(Main.Prompt.Line3, 0, Main.Prompt.Y+90-3, Enums.Width, "center")
		love.graphics.printf(Main.Prompt.Line4, 0, Main.Prompt.Y+102-3, Enums.Width, "center")
		love.graphics.printf(Main.Prompt.Line5, 0, Main.Prompt.Y+114-3, Enums.Width, "center")
		--choices
		love.graphics.printf(Main.Prompt.Choice1, 0, Main.Prompt.Y+144-3, Enums.Width, "center")
		love.graphics.printf(Main.Prompt.Choice2, 0, Main.Prompt.Y+172-3, Enums.Width, "center")
		--title
		love.graphics.printf(Main.Prompt.Title, 0, Main.Prompt.Y+41-3, Enums.Width, "center")
	end
	if #Main.Hovering > 0 then
		for k,v in ipairs(Main.Hovering) do
			love.graphics.setColor(0.75,0.75,0.75, 1-(v.r*0.025))
			love.graphics.circle( "line", v.x, v.y, v.r, 32)
			v.r = v.r + 1.25
			if v.r >= 100 then
				table.remove(Main.Hovering, k)
			end
		end
	end
	love.graphics.setColor(1,1,1)
	--end prompts
	love.graphics.setCanvas() --This sets the target back to the screen
	love.graphics.setColor(1,1,1,Main.Boot) --#FFFFFF
	love.graphics.draw(Canvas, 0, 0, 0, Data.Scaling, Data.Scaling)
end
function love.update(dt)
	if Main.Prompt ~= nil then
		if Main.Prompt.State == Enums.PromptOpen then
			if Data.InstantPrompts ~= true then
				if Main.Prompt.Y < 0 then
					Main.Prompt.Y = Main.Prompt.Y + 10
				else
					Main.Prompt.Y = 0
					Main.Prompt.State = Enums.PromptStay
				end
			else
				Main.Prompt.Y = 0
				Main.Prompt.State = Enums.PromptStay
			end
		elseif Main.Prompt.State == Enums.PromptClose then
			if Data.InstantPrompts ~= true then
				if Main.Prompt.Y < 240 then
					Main.Prompt.Y = Main.Prompt.Y + 10
				else
					Main.Prompt = nil
				end
			else
				Main.Prompt = nil
			end
		end
	end
	if Main.Boot < 1 then --boot sequence
		Main.Boot = Main.Boot + 0.005 --despacito
	end
	--screen change fading
	if Main.Fade == Enums.FadeOut and Main.ScreenWait < 1 then --fade to white
		Main.ScreenWait = Main.ScreenWait + 0.1
	elseif Main.Fade == Enums.FadeOut then --begin fade in and change to new screen
		Main.Fade = Enums.FadeIn
		Main.LastScreen = Main.ActiveScreen
		Main.ActiveScreen = Main.NextScreen
		if Main.LastScreen >= Enums.LastScreen then
			Main.TextEntry = "" --reset text entry
			Main.OldTextBuffer = ""
			Main.LastScreen = Enums.Menu
			Save()
		end
	end
	if Main.Fade == Enums.FadeIn and Main.ScreenWait > 0 then --fade out from white into new screen
		Main.ScreenWait = Main.ScreenWait - 0.1
	elseif Main.Fade == Enums.FadeIn then --fade over
		Main.ScreenWait = 0
		Main.Fade = Enums.FadeNone
	end
	-- scrolling bg and flipping
	Main.W = Main.W + 1
	if Main.W == 3 then --slow down animations so they're not too fast
		if Main.Flipping == true and Main.Flip > -10 then --logo flip
			Main.Flip = Main.Flip - 1
		elseif Main.Flip == -10 then --that's enough flipping
			Main.Flipping = false
			Main.Flip = 0
			Audio.Back:play()
		end
		if Data.BackgroundType < Enums.BackgroundStatic then
			Main.X = Main.X + 1
			Main.Y = Main.Y + 1
		end
		Main.W = 0
	end
	if Main.X >= Enums.BackgroundSize then Main.X = 0 end --reset to original x flawlessly
	if Main.Y >= Enums.BackgroundSize then Main.Y = 0 end --ditto with y
end
function love.mousepressed( x, y, button, istouch, presses )
	Main.Boot = 1 --disable boot sequence
	x = x/Data.Scaling --scale up mouse x
	y = y/Data.Scaling --ditto with y
	love.audio.stop()
	if Main.Prompt == nil then
		if Main.ActiveScreen == Enums.Menu then
			if x >= 2 and y >= 2 and x < 19 and y < 19 then --back button
				Main.NextScreen = Main.LastScreen
				Main.Fade = Enums.FadeOut
				Audio.Back:play()
			elseif x >= 22 and y >= 89 and x < 58 and y < 98 then --generate
				if promptytpcli() then
					Main.NextScreen = Enums.Generate
					Main.Fade = Enums.FadeOut
					Audio.Select:play()
				end
			elseif x >= 22 and y >= 113 and x < 49 and y < 122 then --plugins
				if promptytpcli() and Data.AllowPlugins == true then
					Main.NextScreen = Enums.Plugins
					Main.Fade = Enums.FadeOut
					Audio.Select:play()
				else
					promptplugins()
				end
			elseif x >= 22 and y >= 137 and x < 51 and y < 146 then --options
				if promptoptions() then
					Main.NextScreen = Enums.Options
					Main.Fade = Enums.FadeOut
					Audio.Select:play()
				end
			elseif x >= 129 and y >= 4 and x < 142 and y < 17 and Main.Flipping == false then --cool logo flip
				Main.Flipping = true
				Audio.Select:play()
			elseif x >= 22 and y >= 161 and x < 37 and y < 170 then --quit
				love.event.quit()
			else
				hover(x, y)
			end
		end
		--screens
		if Main.ActiveScreen == Enums.Generate then
			if x >= 2 and y >= 2 and x < 19 and y < 19 then --back button
				Main.NextScreen = Main.LastScreen
				Main.Fade = Enums.FadeOut
				Audio.Back:play()
			elseif x >= 301 and y >= 112 and x < 316 and y < 126 then --import
				Audio.Prompt:play()
				local prompt = {}
				prompt.Title = "importing a clip"
				prompt.Line2 = "there is currently no way to select files."
				prompt.Line3 = "to import a video file, drag and drop it here."
				prompt.Line4 = "it will be added and saved to your source list."
				prompt.Line1 = ""
				prompt.Line5 = ""
				prompt.Choice1 = ""
				prompt.Callback1 = function() end
				prompt.Callback2 = function() end
				prompt.Choice2 = "okay"
				prompt.Y = -240
				prompt.State = Enums.PromptOpen
				Main.Prompt = prompt
				return false
			elseif x >= 4 and y >= 112 and x < 19 and y < 126 then --up
				if Main.Cursor > 0 then
					Audio.Option:play()
					Main.Cursor = Main.Cursor-1
				else
					Audio.Prompt:play()
				end
			elseif x >= 19 and y >= 112 and x < 34 and y < 126 then --down
				if Main.Cursor+6 < #Data.Generate.Sources then
					Audio.Option:play()
					Main.Cursor = Main.Cursor+1
				else
					Audio.Prompt:play()
				end
			elseif x >= 4 and y >= 128 and x < 41 and y < 143 then --output
				Main.TextEntry = "Output"
				Main.OldTextBuffer = Data.Generate[Main.TextEntry]
				Main.NextScreen = Enums.TextOutput
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			elseif x >= 102 and y >= 144 and x < 117 and y < 159 then --debugging
				Data.Generate.Debugging = not Data.Generate.Debugging
				Audio.Option:play()
			elseif x >= 120 and y >= 161 and x < 149 and y < 176 then --min stream
				Main.TextEntry = "MinStream"
				Main.OldTextBuffer = Data.Generate[Main.TextEntry]
				Main.NextScreen = Enums.TextMinStream
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			elseif x >= 124 and y >= 178 and x < 153 and y < 193 then --max stream
				Main.TextEntry = "MaxStream"
				Main.OldTextBuffer = Data.Generate[Main.TextEntry]
				Main.NextScreen = Enums.TextMaxStream
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			elseif x >= 50 and y >= 195 and x < 79 and y < 210 then --clips
				Main.TextEntry = "Clips"
				Main.OldTextBuffer = Data.Generate[Main.TextEntry]
				Main.NextScreen = Enums.TextClips
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			elseif x >= 52 and y >= 212 and x < 81 and y < 227 then --width
				Main.TextEntry = "Width"
				Main.OldTextBuffer = Data.Generate[Main.TextEntry]
				Main.NextScreen = Enums.TextWidth
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			elseif x >= 90 and y >= 212 and x < 119 and y < 227 then --height
				Main.TextEntry = "Height"
				Main.OldTextBuffer = Data.Generate[Main.TextEntry]
				Main.NextScreen = Enums.TextHeight
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			elseif x >= 163 and y >= 127 and x < 216 and y < 142 then --plugin test
				Main.TextEntry = "PluginTest"
				Main.OldTextBuffer = Data.Generate[Main.TextEntry]
				Main.NextScreen = Enums.TextPluginTest
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			elseif x >= 301 and y >= 127 and x < 316 and y < 142 then --plugin test active
				Data.Generate.PluginTestActive = not Data.Generate.PluginTestActive
				Audio.Option:play()
			elseif x >= 163 and y >= 143 and x < 216 and y < 160 then --transitions
				Main.NextScreen = Enums.Transitions
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			elseif x >= 218 and y >= 144 and x < 233 and y < 159 then --transitions active
				Data.Generate.TransitionsActive = not Data.Generate.TransitionsActive
				Audio.Option:play()
			elseif x >= 182 and y >= 161 and x < 211 and y < 176 then --fps
				Main.TextEntry = "FPS"
				Main.OldTextBuffer = Data.Generate[Main.TextEntry]
				Main.NextScreen = Enums.TextFPS
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			elseif x >= 150 and y >= 114 and x < 169 and y < 121 then --clear (all of the buttons above to minstream including this one are 1 pixel overshot on the y axis...)
				Data.Generate.Sources = {}
				Save()
				Audio.Option:play()    
			elseif x >= 248 and y >= 1 and x < 318 and y < 18 then --render and open
				Render()
			--remove buttons
			elseif x >= 301 and y >= 23 and x < 316 and y < 36 and #Data.Generate.Sources >= 1 and Main.Cursor < #Data.Generate.Sources then
				Audio.Option:play()
				table.remove(Data.Generate.Sources,Main.Cursor+1)
				Save()
				--[[if Main.Cursor == #Data.Generate.Sources-6 and (Main.Cursor-1) > 0 then --not working
					Main.Cursor = Main.Cursor + 1
				end]]
			elseif x >= 301 and y >= 37 and x < 316 and y < 51 and #Data.Generate.Sources >= 2 and Main.Cursor < #Data.Generate.Sources then
				Audio.Option:play()
				table.remove(Data.Generate.Sources,Main.Cursor+2)
				Save()
				--[[if Main.Cursor == #Data.Generate.Sources-6 and (Main.Cursor-1) > 0 then --not working
					Main.Cursor = Main.Cursor + 1
				end]]
			elseif x >= 301 and y >= 53 and x < 316 and y < 66 and #Data.Generate.Sources >= 3 and Main.Cursor < #Data.Generate.Sources then
				Audio.Option:play()
				table.remove(Data.Generate.Sources,Main.Cursor+3)
				Save()
				--[[if Main.Cursor == #Data.Generate.Sources-6 and (Main.Cursor-1) > 0 then --not working
					Main.Cursor = Main.Cursor + 1
				end]]
			elseif x >= 301 and y >= 67 and x < 316 and y < 81 and #Data.Generate.Sources >= 4 and Main.Cursor < #Data.Generate.Sources then
				Audio.Option:play()
				table.remove(Data.Generate.Sources,Main.Cursor+4)
				Save()
				--[[if Main.Cursor == #Data.Generate.Sources-6 and (Main.Cursor-1) > 0 then --not working
					Main.Cursor = Main.Cursor + 1
				end]]
			elseif x >= 301 and y >= 82 and x < 316 and y < 96 and #Data.Generate.Sources >= 5 and Main.Cursor < #Data.Generate.Sources then
				Audio.Option:play()
				table.remove(Data.Generate.Sources,Main.Cursor+5)
				Save()
				--[[if Main.Cursor == #Data.Generate.Sources-6 and (Main.Cursor-1) > 0 then --not working
					Main.Cursor = Main.Cursor + 1
				end]]
			elseif x >= 301 and y >= 97 and x < 316 and y < 111 and #Data.Generate.Sources >= 6 and Main.Cursor < #Data.Generate.Sources then
				Audio.Option:play()
				table.remove(Data.Generate.Sources,Main.Cursor+6)
				Save()
				--[[if Main.Cursor == #Data.Generate.Sources-6 and (Main.Cursor-1) > 0 then --not working
					Main.Cursor = Main.Cursor + 1
				end]]
			else
				hover(x, y)
			end
		elseif Main.ActiveScreen == Enums.Transitions then
			if x >= 2 and y >= 2 and x < 19 and y < 19 then --back button
				Main.NextScreen = Main.LastScreen
				Main.Fade = Enums.FadeOut
				Audio.Back:play()
			elseif x >= 301 and y >= 222 and x < 316 and y < 236 then --import
				Audio.Prompt:play()
				local prompt = {}
				prompt.Title = "importing a clip"
				prompt.Line2 = "there is currently no way to select files."
				prompt.Line3 = "to import a video file, drag and drop it here."
				prompt.Line4 = "it will be added and saved to your transition list."
				prompt.Line1 = ""
				prompt.Line5 = ""
				prompt.Choice1 = ""
				prompt.Callback1 = function() end
				prompt.Callback2 = function() end
				prompt.Choice2 = "okay"
				prompt.Y = -240
				prompt.State = Enums.PromptOpen
				Main.Prompt = prompt
				return false
			elseif x >= 4 and y >= 222 and x < 19 and y < 235 then --up
				if Main.TransitionCursor > 0 then
					Audio.Option:play()
					Main.TransitionCursor = Main.TransitionCursor-1
				else
					Audio.Prompt:play()
				end
			elseif x >= 19 and y >= 222 and x < 34 and y < 236 then --down
				if Main.TransitionCursor+6 < #Data.Generate.Sources then
					Audio.Option:play()
					Main.TransitionCursor = Main.TransitionCursor+1
				else
					Audio.Prompt:play()
				end
			elseif x >= 150 and y >= 224 and x < 169 and y < 231 then --clear
				Data.Generate.Transitions = {}
				Save()
				Audio.Option:play()
			elseif x >= 301 and y >= 23 and x < 316 and y < 36 and #Data.Generate.Transitions >= 1 and Main.TransitionCursor < #Data.Generate.Transitions then
				Audio.Option:play()
				table.remove(Data.Generate.Transitions,Main.TransitionCursor+1)
				Save()
			elseif x >= 301 and y >= 37 and x < 316 and y < 51 and #Data.Generate.Transitions >= 2 and Main.TransitionCursor < #Data.Generate.Transitions then
				Audio.Option:play()
				table.remove(Data.Generate.Transitions,Main.TransitionCursor+2)
				Save()
			elseif x >= 301 and y >= 53 and x < 316 and y < 66 and #Data.Generate.Transitions >= 3 and Main.TransitionCursor < #Data.Generate.Transitions then
				Audio.Option:play()
				table.remove(Data.Generate.Transitions,Main.TransitionCursor+3)
				Save()
			elseif x >= 301 and y >= 67 and x < 316 and y < 81 and #Data.Generate.Transitions >= 4 and Main.TransitionCursor < #Data.Generate.Transitions then
				Audio.Option:play()
				table.remove(Data.Generate.Transitions,Main.TransitionCursor+4)
				Save()
			elseif x >= 301 and y >= 82 and x < 316 and y < 96 and #Data.Generate.Transitions >= 5 and Main.TransitionCursor < #Data.Generate.Transitions then
				Audio.Option:play()
				table.remove(Data.Generate.Transitions,Main.TransitionCursor+5)
				Save()
			elseif x >= 301 and y >= 97 and x < 316 and y < 111 and #Data.Generate.Transitions >= 6 and Main.TransitionCursor < #Data.Generate.Transitions then
				Audio.Option:play()
				table.remove(Data.Generate.Transitions,Main.TransitionCursor+6)
				Save()
			else
				hover(x, y)
			end
		elseif Main.ActiveScreen >= Enums.LastScreen and Main.ActiveScreen < Enums.TotalScreens+1 and Data.Generate[Main.TextEntry] ~= nil then --text entry
			if x >= 2 and y >= 2 and x < 19 and y < 19 then --back button
				Main.NextScreen = Main.LastScreen
				Main.Fade = Enums.FadeOut
				Audio.Back:play()
			elseif x >= 294 and y >= 2 and x < 318 and y < 19 then --enter
				Data.Generate[Main.TextEntry] = Main.OldTextBuffer
				Main.NextScreen = Main.LastScreen
				Main.Fade = Enums.FadeOut
				Audio.Select:play()
			else
				hover(x, y)
			end
		end
	elseif Main.Prompt.State == Enums.PromptStay then  
		if x >= 2 and y >= 2 and x < 19 and y < 19 then --back button
			Main.NextScreen = Main.LastScreen
			Main.Fade = Enums.FadeOut
			Audio.Back:play()
		elseif x >= 50 and y >= 135 and x < 270 and y < 161 and Main.Prompt.Choice1 ~= "" then --option 1
			Main.Prompt.State = Enums.PromptClose
			Main.Prompt.Callback1()
			Audio.Select:play()
		elseif x >= 50 and y >= 163 and x < 270 and y < 189 then --option 2
			Main.Prompt.State = Enums.PromptClose
			Main.Prompt.Callback2()
			Audio.Select:play()
		else
			hover(x, y)
		end
	end
end
--scroll wheel
function love.wheelmoved(x, y)
	if Data.InvertScrollWheel == true then
		y = y * -1
	end
	if Main.ActiveScreen == Enums.Generate then   
		if y < 0 and Main.Cursor+6 < #Data.Generate.Sources then --down
			Main.Cursor = Main.Cursor+1
		elseif y > 0 and Main.Cursor > 0 then --up
			Main.Cursor = Main.Cursor-1
		end
	elseif Main.ActiveScreen == Enums.Transitions then
		if y < 0 and Main.TransitionCursor+13 < #Data.Generate.Transitions then --down
			Main.TransitionCursor = Main.TransitionCursor+1
		elseif y > 0 and Main.TransitionCursor > 0 then --up
			Main.TransitionCursor = Main.TransitionCursor-1
		end
	end
end
function love.keypressed(k)
	--alt operators
	if love.keyboard.isDown("ralt") or love.keyboard.isDown("lalt") then
		if k == "left" and Main.ActiveScreen ~= Enums.Menu then --back, same as pressing the button
			Main.NextScreen = Main.LastScreen
			Main.Fade = Enums.FadeOut
			Audio.Back:play()
		elseif k == "right" and Main.ActiveScreen == Enums.Menu and Main.LastScreen ~= Enums.Menu then --forward! beat that B) my code is cooler B) im cooler B) - nuppington
			Main.NextScreen = Main.LastScreen
			Main.Fade = Enums.FadeOut
			Audio.Back:play()
		end
	--navigation operators
	elseif k == "home" then
		Main.NextScreen = Enums.Menu
		Main.Fade = Enums.FadeOut
		Audio.Back:play()
	elseif k == "end" then
		Main.NextScreen = Enums.LastScreen-1
		Main.Fade = Enums.FadeOut
		Audio.Back:play()
	--up and down buttons can break submenus, remove if needed
	elseif k == "pageup" and Main.ActiveScreen - 1 >= Enums.Menu and Main.ActiveScreen ~= Enums.Menu then --up
		Main.NextScreen = Main.ActiveScreen - 1
		Main.Fade = Enums.FadeOut
		Audio.Select:play()
	elseif k == "pagedown" and Main.ActiveScreen + 1 < Enums.LastScreen then --down
		Main.NextScreen = Main.ActiveScreen + 1
		Main.Fade = Enums.FadeOut
		Audio.Select:play()
	--text entry
	elseif Main.ActiveScreen >= Enums.LastScreen and Main.ActiveScreen < Enums.TotalScreens+1 and Data.Generate[Main.TextEntry] ~= nil then
		if love.keyboard.isDown("rctrl") or love.keyboard.isDown("lctrl") then --ctrl operators
			if k == "v" then
				Main.OldTextBuffer = Main.OldTextBuffer..love.system.getClipboardText()
			end
		elseif k == "backspace" then --https://love2d.org/wiki/love.textinput
			-- get the byte offset to the last UTF-8 character in the string.
			local byteoffset = utf8.offset(Main.OldTextBuffer, -1)
			if byteoffset then
				-- remove the last UTF-8 character.
				-- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
				Main.OldTextBuffer = string.sub(Main.OldTextBuffer, 1, byteoffset - 1)
			end
		elseif k == "delete" then
			Main.OldTextBuffer = ""
		elseif k == "escape" then
			Main.OldTextBuffer = Data.Generate[Main.TextEntry]
		elseif k == "return" then
			Data.Generate[Main.TextEntry] = Main.OldTextBuffer
			Main.NextScreen = Main.LastScreen
			Main.Fade = Enums.FadeOut
			Audio.Select:play()
		end
	end
end
function love.textinput( text )
	if Main.ActiveScreen >= Enums.LastScreen and Main.ActiveScreen < Enums.TotalScreens+1 and Data.Generate[Main.TextEntry] ~= nil then
		Main.OldTextBuffer = Main.OldTextBuffer..text
	end
end
function love.filedropped( file )
	local filename = file:getFilename()
	love.audio.stop()
	if Main.ActiveScreen == Enums.Generate then
		table.insert(Data.Generate.Sources, filename)
		Audio.Save:play()
		if #Data.Generate.Sources - 6 > 0 then
			Main.Cursor = #Data.Generate.Sources - 6
		end
		Save()
	elseif Main.ActiveScreen == Enums.Transitions then
		table.insert(Data.Generate.Transitions, filename)
		Audio.Save:play()
		if #Data.Generate.Transitions - 13 > 0 then
			Main.TransitionCursor = #Data.Generate.Transitions - 13
		end
		Save()
	end
end
function Render()
	Save()
	Audio.Prompt:play()
	local prompt = {}
	if Data.Generate.Output ~= "" and Data.Generate.Output ~= nil then
		prompt.Title = "render video"
		prompt.Line1 = "rendering will launch ytp+ cli in the background."
		prompt.Line2 = "ytp+ studio will be paused until completion."
		prompt.Line3 = "we'll try to open the file if its output is a full path."
		prompt.Line4 = ""
		prompt.Line5 = "would you like to proceed?"
		prompt.Choice1 = "yes"
		prompt.Callback1 = function()
			local writeto = ""
			for k,v in pairs(Data.Generate.Sources) do
				if writeto == "" then
					writeto = v
				else
					writeto = writeto.."\n"..v
				end
			end
			love.filesystem.write("videos.txt", writeto)
			writeto = ""
			for k,v in pairs(Data.Generate.Transitions) do
				if writeto == "" then
					writeto = v
				else
					writeto = writeto.."\n"..v
				end
			end
			love.filesystem.write("transitions.txt", writeto)
			local cwd = love.filesystem.getSaveDirectory()
			if love.system.getOS() == "Windows" then
				cwd = love.filesystem.getWorkingDirectory()
			end
			local cmd = "node \""..cwd.."/YTPPlusCLI/index.js\" --skip=true --width="..Data.Generate.Width.." --height="..Data.Generate.Height.." --fps="..Data.Generate.FPS.." --input=\""..love.filesystem.getSaveDirectory().."/videos.txt\" --output=\""..Data.Generate.Output.."\" --clips="..Data.Generate.Clips.." --minstream="..Data.Generate.MinStream.." --maxstream="..Data.Generate.MaxStream.." --transitions=\""..love.filesystem.getSaveDirectory().."/transitions.txt\""
			if Data.Generate.Debugging == true then
				cmd = cmd.." --debug"
			end
			if Data.Generate.TransitionsActive == true then
				cmd = cmd.." --usetransitions"
			end
			if Data.Generate.PluginTestActive == true then
				cmd = cmd.." --plugintest="..Data.Generate.PluginTest
			end
			love.filesystem.write("command.txt", cmd)
			os.execute(cmd)
			love.system.openURL(Data.Generate.Output)
			promptrendering()
		end
		prompt.Callback2 = function() end
		prompt.Choice2 = "no"
		prompt.Y = -240
		prompt.State = Enums.PromptOpen
	else
		prompt.Title = "no output file"
		prompt.Line1 = "please set an output file before rendering."
		prompt.Line2 = "the output file must be in a full path that exists."
		prompt.Line3 = "setting the output file will allow for rendering."
		prompt.Line4 = ""
		prompt.Line5 = "example: \"c:\\myvideo.mp4\" is valid."
		prompt.Choice1 = ""
		prompt.Callback1 = function() end
		prompt.Callback2 = function() end
		prompt.Choice2 = "okay"
		prompt.Y = -240
		prompt.State = Enums.PromptOpen
	end
	Main.Prompt = prompt
end
function promptnotimplemented()
	Audio.Prompt:play()
	local prompt = {}
	prompt.Title = "not implemented"
	prompt.Line1 = ""
	prompt.Line2 = ""
	prompt.Line3 = "this feature is currently not implemented."
	prompt.Line4 = ""
	prompt.Line5 = ""
	prompt.Choice1 = ""
	prompt.Callback1 = function() end
	prompt.Callback2 = function() end
	prompt.Choice2 = "okay"
	prompt.Y = -240
	prompt.State = Enums.PromptOpen
	Main.Prompt = prompt
end
function promptytpcli()
	local info = love.filesystem.getInfo("/YTPPlusCLI")
	if not info then --does not exist
		Audio.Prompt:play()
		local prompt = {}
		prompt.Title = "ytp+ cli wasn't found"
		prompt.Line1 = ""
		prompt.Line2 = "ytp+ cli was not detected properly."
		prompt.Line3 = "please re-install at ytp-plus.github.io"
		prompt.Line4 = "windows installation may differ."
		prompt.Line5 = ""
		prompt.Choice1 = ""
		prompt.Callback1 = function() end
		prompt.Callback2 = function() end
		prompt.Choice2 = "okay"
		prompt.Y = -240
		prompt.State = Enums.PromptOpen
		Main.Prompt = prompt
		return false
	else
		return true
	end
end
function promptoptions()
	if Data.AllowOptions == nil then --enable options menu
		Audio.Prompt:play()
		local prompt = {}
		prompt.Title = "no options here"
		prompt.Line1 = "the options menu is not currently available."
		prompt.Line2 = "you may modify options by opening settings.txt."
		prompt.Line3 = "it will open using its default association."
		prompt.Line4 = ""
		prompt.Line5 = "would you like to proceed?"
		prompt.Choice1 = "yes"
		prompt.Callback1 = function()
			love.system.openURL(love.filesystem.getSaveDirectory().."/settings.txt")
			prompt = {}
			prompt.Title = "restart"
			prompt.Line1 = ""
			prompt.Line2 = ""
			prompt.Line3 = "would you like to restart?"
			prompt.Line4 = ""
			prompt.Line5 = ""
			prompt.Choice1 = "yes"
			prompt.Callback1 = function()
				love.event.quit( "restart" )
			end
			prompt.Callback2 = function() end
			prompt.Choice2 = "no"
			prompt.Y = -240
			prompt.State = Enums.PromptOpen
			Main.Prompt = prompt
		end
		prompt.Callback2 = function() end
		prompt.Choice2 = "no"
		prompt.Y = -240
		prompt.State = Enums.PromptOpen
		Main.Prompt = prompt
		return false
	else
		return true
	end
end
function promptplugins()
	Audio.Prompt:play()
	local prompt = {}
	prompt.Title = "plugins aren't yet available"
	prompt.Line1 = ""
	prompt.Line2 = "you can temporarily set plugins by"
	prompt.Line3 = "removing or adding files in"
	prompt.Line4 = "ytppluscli/plugins/ and rendering."
	prompt.Line5 = ""
	prompt.Choice1 = "open ytppluscli/plugins/"
	prompt.Callback1 = function()
		love.system.openURL(love.filesystem.getWorkingDirectory().."/YTPPlusCLI")
	end
	prompt.Callback2 = function() end
	prompt.Choice2 = "okay"
	prompt.Y = -240
	prompt.State = Enums.PromptOpen
	Main.Prompt = prompt
	return false
end
function promptrendering()
	Audio.Prompt:play()
	local prompt = {}
	prompt.Title = "how did rendering go?"
	prompt.Line1 = "if the video didn't open and"
	prompt.Line2 = "the file doesn't exist, feel free"
	prompt.Line3 = "to ask us on our discord for help!"
	prompt.Line4 = ""
	prompt.Line5 = "you may also manually troubleshoot."
	prompt.Choice1 = "open command.txt"
	prompt.Callback1 = function()
		love.system.openURL(love.filesystem.getSaveDirectory().."/command.txt")
	end
	prompt.Callback2 = function() end
	prompt.Choice2 = "okay"
	prompt.Y = -240
	prompt.State = Enums.PromptOpen
	Main.Prompt = prompt
	return false
end
function Save()
	if not love.keyboard.isDown("lshift") then
		love.filesystem.write("settings.txt",TSerial.pack(Data, nil, true)) --save data
	end
end
function hover(x, y)
	Audio.Hover:play()
	table.insert(Main.Hovering, {x=x, y=y, r=1})
end
