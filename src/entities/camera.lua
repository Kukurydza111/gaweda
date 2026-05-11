-- A simple 2D camera that follows the player and clamps to map bounds.
-- Usage: call camera.set(c) before drawing the world, camera.unset() after.
local camera = {}

-- Creates a new camera positioned at the world origin.
function camera.create()
    local c = {
        x = 0,
        y = 0
    }
    return c
end

-- Centers the camera on the player, then clamps so it never shows outside the map.
function camera.update(c, player, screenPixelWidth, screenPixelHeight, mapPixelWidth, mapPixelHeight)
    -- Center on player
    c.x = player.x - screenPixelWidth / 2
    c.y = player.y - screenPixelHeight / 2

    -- Clamp so the viewport stays within the map boundaries
    c.x = math.max(0, math.min(c.x, mapPixelWidth - screenPixelWidth))
    c.y = math.max(0, math.min(c.y, mapPixelHeight - screenPixelHeight))

    -- Uncomment to snap to whole pixels (eliminates sub-pixel jitter at the cost of smoother motion)
    -- c.x = math.floor(c.x)
    -- c.y = math.floor(c.y)
end

-- Applies the camera transform: pushes a new graphics state and translates by the camera offset.
-- Everything drawn after this call is shifted so the camera position maps to the top-left of the screen.
function camera.set(c)
    love.graphics.push()
    love.graphics.translate(-c.x, -c.y)
end

-- Restores the graphics state to before camera.set was called.
function camera.unset()
    love.graphics.pop()
end


return camera
