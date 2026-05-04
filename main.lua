statemachine = require("src/core/statemachine")
glob = {}

function love.load()
    love.window.setMode(0, 0, {fullscreen = true})
    love.graphics.setDefaultFilter("nearest", "nearest")

    local screenWidth, screenHeight = love.graphics.getPixelDimensions()
    glob.scale = 4
    glob.pixelwidth = screenWidth / glob.scale
    glob.pixelheight = screenHeight / glob.scale
    glob.canvas = love.graphics.newCanvas(glob.pixelwidth, glob.pixelheight)
    glob.titlefont = love.graphics.newFont("assets/fonts/LuckiestGuy.ttf", 50)
    glob.mainfont = love.graphics.newFont("assets/fonts/PixelifySans.ttf")

    statemachine.register("game", require("src/states/game"))
    statemachine.register("menu", require("src/states/menu"))
    statemachine.switch("menu")
end

function love.keypressed(key)
    statemachine.keypressed(key)
end

function love.update(dt)
    statemachine.update(dt)
end

function love.draw()
    statemachine.draw()
end
