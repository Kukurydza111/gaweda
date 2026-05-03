map = require("src/entities/map")
player = require("src/entities/player")

local game = {
    scale = 4,
    pixelWidth = 480,
    pixelHeight = 270,
    player = nil,
    map = nil
}

function game.load()
    love.window.setMode(0, 0, {fullscreen = true})
    love.graphics.setDefaultFilter("nearest", "nearest")
    local screenWidth, screenHeight = love.graphics.getPixelDimensions()
    game.pixelwidth = screenWidth / game.scale
    game.pixelheight = screenHeight / game.scale
    game.canvas = love.graphics.newCanvas(game.pixelwidth, game.pixelheight)
    game.player = player.create()
    game.map = map.load("assets/maps/poziom1")
end

function game.update(dt)

    -- klawisz ESC wychodzi z gry
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    player.update(game.player, dt)

end

function game.draw()

    love.graphics.setCanvas(game.canvas)
    love.graphics.clear(0, 0, 0, 1)

    -- draw map
    map.drawLayer(game.map, 1, 0, 0, 0, 0, game.pixelwidth, game.pixelheight)
    -- draw player
    player.draw(game.player)

    love.graphics.setCanvas()
    love.graphics.draw(game.canvas, 0, 0, 0, game.scale, game.scale)

end


return game
