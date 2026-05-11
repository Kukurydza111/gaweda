-- Main entry point for the game
statemachine = require("src/core/statemachine")
glob = {}  -- Global table for game-wide variables

function love.load()
    -- Set up full-screen window with no border
    love.window.setMode(0, 0, {fullscreen = true})
    
    -- Set nearest-neighbor filtering for pixel art look
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Calculate pixel dimensions for low-res canvas
    local screenWidth, screenHeight = love.graphics.getPixelDimensions()
    glob.scale = 4  -- Scale factor (4x)
    glob.pixelwidth = screenWidth / glob.scale  -- Low-res width
    glob.pixelheight = screenHeight / glob.scale  -- Low-res height
    
    -- Create a low-res canvas for retro style rendering
    glob.canvas = love.graphics.newCanvas(glob.pixelwidth, glob.pixelheight)
    
    -- Load custom fonts
    glob.titlefont = love.graphics.newFont("assets/fonts/LuckiestGuy.ttf", 50)
    glob.mainfont = love.graphics.newFont("assets/fonts/PixelifySans.ttf")

    -- Register game states in the state machine
    statemachine.register("menu", require("src/states/menu"))      -- Main menu state
    statemachine.register("game", require("src/states/game"))      -- Gameplay state
    statemachine.register("dialog", require("src/states/dialog"))  -- Dialogue state
    
    -- Start in menu state
    statemachine.switch("menu")
end

function love.keypressed(key)
    -- Forward key input to the current state
    statemachine.keypressed(key)
end

function love.update(dt)
    -- Update current state with delta time
    statemachine.update(dt)
end

function love.draw()
    -- Draw to low-res canvas instead of screen directly
    love.graphics.setCanvas(glob.canvas)
    love.graphics.clear(0, 0, 0, 1)  -- Clear with black background

    -- Draw the current state's content
    statemachine.draw()

    -- Switch back to screen canvas
    love.graphics.setCanvas()
    
    -- Draw the low-res canvas scaled up to full screen
    love.graphics.draw(glob.canvas, 0, 0, 0, glob.scale, glob.scale)
end
