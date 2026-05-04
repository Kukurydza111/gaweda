sprite = require("src/entities/sprite")

local character = {}

function character.create(characterName, dx, dy)
    local c = {
        name = characterName,
        dx = dx or 60,
        dy = dy or 45,
        collisionBox = {
            offsetX = 0,
            offsetY = 22,
            width = 16,
            height = 12
        },
        sprite = sprite.load(characterName),
        state = "idle"
    }
    return c
end

function character.update(c, dt)
    if c.sprite then
        sprite.update(c.sprite, c.state, dt)
    end
end

return character
