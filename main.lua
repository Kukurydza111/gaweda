game = require("src/core/game")

function love.load()
    love.window.setMode(0, 0, {fullscreen = true})
    love.graphics.setDefaultFilter("nearest", "nearest")

    game.load()
end

function love.update(dt)
    game.update(dt)
end

function love.draw()
    game.draw()
end
