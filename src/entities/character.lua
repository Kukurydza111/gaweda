sprite = require("src/entities/sprite")

local character = {}

-- Creates a new character instance.
-- characterName: used to load the correct sprite sheet and identify the character
-- dx, dy: tile-grid offsets (pixels from tile origin to character draw position); defaults to 60x45
-- collisionBox: a sub-rectangle within the sprite used for collision detection (offset + size in pixels)
-- state: animation state, starts as "idle"
function character.create(characterName, dx, dy)
    local c = {
        name = characterName,
        dx = dx or 60,
        dy = dy or 45,
        collisionBox = {
            offsetX = 0,
            offsetY = 22,  -- shifted down 22px so the box sits at the character's feet
            width = 16,
            height = 12
        },
        sprite = sprite.load(characterName),
        state = "idle"
    }
    return c
end

-- Advances the character's sprite animation by dt seconds, based on the current state.
function character.update(c, dt)
    if c.sprite then
        sprite.update(c.sprite, c.state, dt)
    end
end

return character
