map = require("src/entities/map")
player = require("src/entities/player")
camera = require("src/entities/camera")

local game = {
    scale = 4,
    pixelWidth = 480,
    pixelHeight = 270,
    player = nil,
    map = nil,
    camera = nil
}

function game.load()
    local screenWidth, screenHeight = love.graphics.getPixelDimensions()
    game.pixelwidth = screenWidth / game.scale
    game.pixelheight = screenHeight / game.scale
    game.canvas = love.graphics.newCanvas(game.pixelwidth, game.pixelheight)
    game.player = player.create()
    game.map = map.load("assets/maps/poziom1")
    game.camera = camera.create()
end

function game.update(dt)

    -- klawisz ESC wychodzi z gry
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    player.update(game.player, game.map, dt)
    camera.update(
        game.camera,
        game.player,
        game.pixelWidth,
        game.pixelHeight,
        game.map.width * game.map.tilewidth,
        game.map.height * game.map.tileheight
    )

end

function game.draw()

    love.graphics.setCanvas(game.canvas)
    love.graphics.clear(0, 0, 0, 1)

    -- set camera
    camera.set(game.camera)
    -- draw map
    map.drawLayer(game.map, 1, 0, 0, 0, 0,
        game.map.width * game.map.tilewidth,
        game.map.height * game.map.tileheight)
    -- draw player
    player.draw(game.player)
    -- unset camera
    camera.unset()

    love.graphics.setCanvas()
    love.graphics.draw(game.canvas, 0, 0, 0, game.scale, game.scale)

end


return game
