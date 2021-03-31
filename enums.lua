return {
    --window options
    Width = 320,
    Height = 240,
    WindowFlags = {
        fullscreen = false,
        fullscreentype = "desktop",
        vsync = 1,
        msaa = 0,
        stencil = true,
        depth = 0,
        resizable = true,
        borderless = false,
        centered = true,
        display = 1,
        minwidth = 320,
        minheight = 240
    },
    BackgroundSize = 28,
    --fade types
    FadeNone = nil,
    FadeOut = 0,
    FadeIn = 1,
    --screens
    Menu = 0,
    Generate = 1,
    Plugins = 2,
    Options = 3,
    LastScreen = 4, --count of how many "real" screens there are
    --text entry screens
    TextOutput = 4,
    TextMinStream = 5,
    TextMaxStream = 6,
    TextClips = 7,
    TextWidth = 8,
    TextHeight = 9,
    TextPluginTest = 10,
    TextTransitions = 11,
    TextFPS = 12,
    --hidden screens
    Transitions = 13,
    TotalScreens = 13, --count of all screens in total
    ScreenNames = {
        [0] = "main menu",
        "generate",
        "plugins",
        "options",
        "text entry - output",
        "text entry - minimum stream duration",
        "text entry - maximum stream duration",
        "text entry - clip count",
        "text entry - width",
        "text entry - height",
        "text entry - plugin test",
        "text entry - transitions",
        "text entry - fps",
        "transitions"
    },
    --prompt states
    PromptOpen = 0,
    PromptStay = 1,
    PromptClose = 2,
    BasePrompt = {
        Title = "",
        Line1 = "",
        Line2 = "",
        Line3 = "",
        Line4 = "",
        Line5 = "",
        Choice1 = "",
        Choice2 = "",
        Callback1 = function() end,
        Callback2 = function() end,
        State = 0,
        Y = -240
    },
    --boot types
    BootNormal = 0,
    BootNoAudio = 1,
    BootNone = 2,
    --background types
    BackgroundNormal = 0,
    BackgroundStatic = 1,
    BackgroundNone = 2,
    BackgroundBlack = 3,
    --fade toggles
    FadeWhite = 1, --used to be 0
    FadeBlack = 0, --used to be 1
    FadeNone = 2,
    --options, not yet implemented
    OptionsNames = {
        Scaling = "window scale",
        BootType = "boot type",
        BackgroundType = "background type",
        LastScreen = "back screen",
        ActiveScreen = "startup screen",
        NextScreen = "next screen",
        FadeType = "fade type",
        Volume = "volume",
        InstantPrompts = "instant prompts"
    },
    OptionsEnums = {
        BootType = {
            [0] = "fade w/sfx",
            "fade silently",
            "none",
            "out of bounds"
        },
        BackgroundType = {
            [0] = "scrolling",
            "static",
            "no tiles",
            "none",
            "out of bounds"
        },
        LastScreen = {
            [0] = "main menu",
            "generate",
            "plugins",
            "options",
            "out of bounds"
        },
        ActiveScreen = {
            [0] = "main menu",
            "generate",
            "plugins",
            "options",
            "out of bounds"
        },
        NextScreen = {
            [0] = "main menu",
            "generate",
            "plugins",
            "options",
            "out of bounds"
        },
        FadeType = {
            [0] = "white flash",
            "black flash",
            "instant",
            "out of bounds"
        },
        InstantPrompts = {
            [true] = "on",
            [false] = "off",
            [0] = "out of bounds",
            [1] = "out of bounds"
        }
    },
    BoolString = {
        [true] = "true",
        [false] = "false",
        [0] = "false"
    }
}
