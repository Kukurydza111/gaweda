local camera = {}

function camera.create()
    local c = {
        x = 0,
        y = 0
    }
    return c
end

function camera.update(c, player, screenPixelWidth, screenPixelHeight, mapPixelWidth, mapPixelHeight)
    c.x = player.x - screenPixelWidth / 2
    c.y = player.y - screenPixelHeight / 2

    c.x = math.max(0, math.min(c.x, mapPixelWidth - screenPixelWidth))
    c.y = math.max(0, math.min(c.y, mapPixelHeight - screenPixelHeight))

    -- c.x = math.floor(c.x)
    -- c.y = math.floor(c.y)
end

function camera.set(c)
    love.graphics.push()
    love.graphics.translate(-c.x, -c.y)
end

function camera.unset()
    love.graphics.pop()
end


return camera
