particles = require("src/entities/particles")
character = require("src/entities/character")

local player = {}

function player.create()
    local p = {
        x = 30,
        y = 100,
        characters = {
            character.create("Marceli", 50, 35),
            character.create("Hania", 50, 35),
            character.create("Witold", 50, 35),
            character.create("Mieszko", 50, 35)
        },
        characterSwitching = false,
        characterSwitchingEffect = particles.newCharacterSwitchEffect()
    }
    p.currentCharacter = p.characters[1]
    return p
end

function player.update(p, dt)

    -- move player
    if love.keyboard.isDown("s") then
        p.y = p.y + p.currentCharacter.dy * dt
        p.currentCharacter.sprite.state = "walkdown"
    elseif love.keyboard.isDown("w") then
        p.y = p.y - p.currentCharacter.dy * dt
        p.currentCharacter.sprite.state = "walkup"
    elseif love.keyboard.isDown("d") then
        p.x = p.x + p.currentCharacter.dx * dt
        p.currentCharacter.sprite.state = "walkright"
    elseif love.keyboard.isDown("a") then
        p.x = p.x - p.currentCharacter.dx * dt
        p.currentCharacter.sprite.state = "walkleft"
    else
        if p.currentCharacter.sprite.state ~= "idle" then
            p.currentCharacter.sprite.state = "idle"
            p.currentCharacter.sprite.frame = 1
        end
    end

    -- update current player character
    character.update(p.currentCharacter, dt)
    
    -- update character switching effect
    if p.characterSwitchingEffect then
        p.characterSwitchingEffect:update(dt)
    end

    -- zmiana postaci
    local key = 0
    if love.keyboard.isDown("1") then key = 1 end
    if love.keyboard.isDown("2") then key = 2 end
    if love.keyboard.isDown("3") then key = 3 end
    if love.keyboard.isDown("4") then key = 4 end

    if key ~= 0 and p.characterSwitching == false and p.characters[key] then
        local state = p.currentCharacter.sprite.state
        local frame = 1
        local animCount = p.currentCharacter.sprite.animSpeed
        p.currentCharacter = p.characters[key]
        p.currentCharacter.sprite.state = state
        p.currentCharacter.sprite.frame = frame
        p.currentCharacter.sprite.animCount = animCount
        particles.triggerEffect(p.characterSwitchingEffect, p.x + 8, p.y + 16, 30)
        p.characterSwitching = true
    elseif key == 0 and p.characterSwitching == true then
        p.characterSwitching = false
    end

end

function player.draw(p)
    -- draw players sprite
    local state = p.currentCharacter.sprite.state
    local frame = p.currentCharacter.sprite.frame
    local image = p.currentCharacter.sprite.animations[state][frame]
    love.graphics.draw(image, p.x, p.y)
    -- draw effects
    love.graphics.draw(p.characterSwitchingEffect, 0, 0)
end

return player
