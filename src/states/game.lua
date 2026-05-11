-- Main gameplay state: handles loading, updating, and drawing the game world.
-- Registered as a state in the statemachine; receives control when gameplay is active.
statemachine = require("src/core/statemachine")
map = require("src/entities/map")
player = require("src/entities/player")
camera = require("src/entities/camera")

local game = {}

-- Initializes the game world: creates the player, loads the map from a Tiled file,
-- and sets up the camera.
function game.load()
    game.player = player.create()
    game.map = map.load("assets/maps/poziom1")
    game.camera = camera.create()
end

function game.update(dt)

    -- ESC quits the game
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    -- SPACE switches to the dialog state, passing this state as context so
    -- dialog can return here when it finishes
    if love.keyboard.isDown("space") then
        statemachine.switch("dialog", game)
    end

    player.update(game.player, game.map, dt)

    -- Keep the camera centred on the player, clamped to map boundaries
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

    love.graphics.setColor(1, 1, 1, 1)

    -- Apply camera transform so everything below is drawn in world space
    camera.set(game.camera)
    -- Draw the first (bottom) map layer, clipped to the full map rect
    map.drawLayer(game.map, 1, 0, 0, 0, 0,
        game.map.width * game.map.tilewidth,
        game.map.height * game.map.tileheight)
    player.draw(game.player)
    -- Restore default transform after world-space drawing
    camera.unset()

end


return game
