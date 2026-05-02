map = require("src/entities/map")

function loadAnimFrames(spriteName, animName)
    sprites[spriteName][animName] = {}
    i = 1
    while true do
        local filename = "assets/images/" .. spriteName .. "/" .. animName .. "_" .. i .. ".png"
        local info = love.filesystem.getInfo(filename)
        if info then
            local image = love.graphics.newImage(filename, {linear = true})
            sprites[spriteName][animName][i] = image
            i = i + 1
        else
            break
        end
    end
end

function loadSprite(name)
    sprites[name] = {}
    loadAnimFrames(name, "walk_down")
    loadAnimFrames(name, "walk_up")
    loadAnimFrames(name, "walk_left")
    loadAnimFrames(name, "walk_right")
    loadAnimFrames(name, "idle")
end

function nextFrame(sprite)
    sprite.frame = sprite.frame + 1
    if sprite.frame > #sprite[sprite.state] then
        sprite.frame = 1
    end
end

function love.load()
    love.window.setMode(0, 0, {fullscreen = true})
    pixelwidth, pixelheight = love.graphics.getPixelDimensions()
    love.graphics.setDefaultFilter("nearest", "nearest")
    gamescale = 4
    pixelwidth = pixelwidth / gamescale
    pixelheight = pixelheight / gamescale
    gamecanvas = love.graphics.newCanvas(pixelwidth, pixelheight)
    x, y, w, h = 0, 200, 16, 16
    dx, dy = 1, 1
    sprites = {}
    loadSprite("Marceli")
    sprites["Marceli"].state = "idle"
    sprites["Marceli"].frame = 1
    animSpeed = 10
    animCount = animSpeed

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
        y = y + dy
        sprites["Marceli"].state = "walk_down"
    elseif love.keyboard.isDown("w") then
        y = y - dy
        sprites["Marceli"].state = "walk_up"
    elseif love.keyboard.isDown("d") then
        x = x + dx
        sprites["Marceli"].state = "walk_right"
    elseif love.keyboard.isDown("a") then
        x = x - dx
        sprites["Marceli"].state = "walk_left"
    else
        if sprites["Marceli"].state ~= "idle" then
            sprites["Marceli"].state = "idle"
            sprites["Marceli"].frame = 1
        end
    end


    if x > pixelwidth - w then
        x = pixelwidth - w
    end
    if x < 0 then
        x = 0
    end
    if y > pixelheight - h then
        y = pixelheight - h
    end
    if y < 0 then
        y = 0
    end

    if animCount <= 0 then
        nextFrame(sprites["Marceli"])
        animCount = animSpeed
    else
        animCount = animCount - 1
    end
end

function love.draw()

    love.graphics.setCanvas(gamecanvas)
    love.graphics.clear(0, 0, 0, 1)

    map.drawLayer(mapa, 1, 0, 0, 0, 0, pixelwidth, pixelheight)
    love.graphics.draw(sprites["Marceli"][sprites["Marceli"].state][sprites["Marceli"].frame], x, y)

    love.graphics.setCanvas()
    love.graphics.draw(gamecanvas, 0, 0, 0, gamescale, gamescale)

end