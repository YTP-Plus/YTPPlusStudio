local tiles = love.graphics.newImage("graphics/tile.png")
local Enums = require("enums")
tiles:setWrap("repeat", "repeat")
return {
    Icon = love.graphics.newImage( "graphics/icon.png" ),
    IconFlipped = love.graphics.newImage( "graphics/icon-export.png" ),
    Back = love.graphics.newImage( "graphics/backbutton.png" ),
    Tiles = tiles,
    TiledQuad = love.graphics.newQuad(0, 0, Enums.Width, Enums.Height, tiles:getWidth(), tiles:getHeight()),
    Munro = {
        Regular = love.graphics.newFont("fonts/munro.ttf", 10, "mono"),
        Small = love.graphics.newFont("fonts/munro-small.ttf", 10, "mono"),
        Narrow = love.graphics.newFont("fonts/munro-narrow.ttf", 10, "mono")
    },
    Cursor = love.mouse.newCursor( love.image.newImageData( "graphics/cursor.png" ), 0, 0 ),
    Prompt = love.graphics.newImage( "graphics/prompt.png" ),
    Choice = love.graphics.newImage( "graphics/choice.png" ),
    Generate = {
        ImportBG = love.graphics.newImage( "graphics/generate/importbg.png" ),
        Down = love.graphics.newImage( "graphics/generate/down.png" ),
        Remove = love.graphics.newImage( "graphics/generate/remove.png" ),
        Up = love.graphics.newImage( "graphics/generate/up.png" ),
        Dividers = {
            PluginTest = love.graphics.newImage( "graphics/generate/plugintestdivider.png" ),
            Import = love.graphics.newImage( "graphics/generate/importdivider.png" ),
            Output = love.graphics.newImage( "graphics/generate/outputdivider.png" )
        },
        Buttons = {
            Checkbox = love.graphics.newImage( "graphics/generate/checkbox.png" ),
            InputField = love.graphics.newImage( "graphics/generate/inputfield.png" ),
            Transitions = love.graphics.newImage( "graphics/generate/transitionsopen.png" ),
            PluginTest = love.graphics.newImage( "graphics/generate/plugintestopen.png" ),
            Output = love.graphics.newImage( "graphics/generate/outputopen.png" )
        }
    },
    Transitions = {
        TransitionsBG = love.graphics.newImage( "graphics/transitions/transitionsbg.png" ),
    }
}
