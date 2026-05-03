sprite = require("src/entities/sprite")

local character = {}

function character.create(characterName, dx, dy)
    local c = {
        name = characterName,
        dx = dx,
        dy = dy,
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
