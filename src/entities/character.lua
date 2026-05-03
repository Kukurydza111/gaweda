sprite = require("src/entities/sprite")

local character = {}

function character.create(characterName, dx, dy)
    local c = {
        name = characterName,
        dx = dx or 50,
        dy = dy or 35,
        collisionBox = {
            offsetX = 0,
            offsetY = 0,
            width = 16,
            height = 32
        },
        sprite = sprite.load(characterName)
    }
    return c
end

function character.update(c, dt)
    if c.sprite then
        sprite.update(c.sprite, dt)
    end
end

return character
