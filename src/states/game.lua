map = require("src/entities/map")
player = require("src/entities/player")
camera = require("src/entities/camera")

local game = {}

function game.load()
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
        glob.pixelwidth,
        glob.pixelheight,
        game.map.width * game.map.tilewidth,
        game.map.height * game.map.tileheight
    )

end

function game.draw()

    love.graphics.setCanvas(glob.canvas)
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
    love.graphics.draw(glob.canvas, 0, 0, 0, glob.scale, glob.scale)

end


return game
