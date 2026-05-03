game = require("src/core/game")
map = require("src/entities/map")
sprite = require("src/entities/sprite")


function nextFrame(s)
    s.frame = s.frame + 1
    if s.frame > #s.animations[s.state] then
        s.frame = 1
    end
end

function love.load()
    love.window.setMode(0, 0, {fullscreen = true})
    game.pixelwidth, game.pixelheight = love.graphics.getPixelDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest")
    game.scale = 4
    game.pixelwidth = game.pixelwidth / game.scale
    game.pixelheight = game.pixelheight / game.scale
    game.canvas = love.graphics.newCanvas(game.pixelwidth, game.pixelheight)
    x, y, w, h = 0, 200, 16, 16
    dx, dy = 50, 35
    game.spriteCollection = {}
    table.insert(game.spriteCollection, sprite.load("Marceli"))
    game.currentSprite = game.spriteCollection[1]

    -- test map
    mapa = map.load("assets/maps/poziom1")
end

function love.update(dt)

    -- klawisz ESC wychodzi z gry
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    -- ruszanie sprite'em
    if love.keyboard.isDown("s") then
        y = y + dy * dt
        game.currentSprite.state = "walkdown"
    elseif love.keyboard.isDown("w") then
        y = y - dy * dt
        game.currentSprite.state = "walkup"
    elseif love.keyboard.isDown("d") then
        x = x + dx * dt
        game.currentSprite.state = "walkright"
    elseif love.keyboard.isDown("a") then
        x = x - dx * dt
        game.currentSprite.state = "walkleft"
    else
        if game.currentSprite.state ~= "idle" then
            game.currentSprite.state = "idle"
            game.currentSprite.frame = 1
        end
    end


    if x > game.pixelwidth - w then
        x = game.pixelwidth - w
    end
    if x < 0 then
        x = 0
    end
    if y > game.pixelheight - h then
        y = game.pixelheight - h
    end
    if y < 0 then
        y = 0
    end

    if game.currentSprite.animCount <= 0 then
        nextFrame(game.currentSprite)
        game.currentSprite.animCount = game.currentSprite.animSpeed
    else
        game.currentSprite.animCount = game.currentSprite.animCount - 1
    end
end

function love.draw()

    love.graphics.setCanvas(game.canvas)
    love.graphics.clear(0, 0, 0, 1)

    map.drawLayer(mapa, 1, 0, 0, 0, 0, game.pixelwidth, game.pixelheight)
    love.graphics.draw(game.currentSprite.animations[game.currentSprite.state][game.currentSprite.frame], x, y)

    love.graphics.setCanvas()
    love.graphics.draw(game.canvas, 0, 0, 0, game.scale, game.scale)

end