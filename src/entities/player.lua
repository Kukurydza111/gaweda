particles = require("src/entities/particles")
character = require("src/entities/character")

local player = {}

function player.create()
    local p = {
        x = 30,
        y = 100,
        characters = {
            character.create("Marceli"),
            character.create("Hania"),
            character.create("Witold"),
            character.create("Mieszko")
        },
        characterSwitching = false,
        characterSwitchingEffect = particles.newCharacterSwitchEffect()
    }
    p.currentCharacter = p.characters[1]
    return p
end

-- check if a collision box at a given point is colliding with anything on map
function player.isColliding(collisionBox, x, y, map)

    playerCB = {
        x1 = x + collisionBox.offsetX,
        y1 = y + collisionBox.offsetY,
        x2 = x + collisionBox.offsetX + collisionBox.width,
        y2 = y + collisionBox.offsetY + collisionBox.height
    }

    -- find the map coorindates of the tile containing top-left corner of player's collisionBox
    mapX = math.floor(playerCB.x1 / map.tilewidth)
    mapY = math.floor(playerCB.y1 / map.tileheight)
    mapW = math.floor(playerCB.x2 / map.tilewidth) - mapX
    mapH = math.floor(playerCB.y2 / map.tileheight) - mapY

    -- go through the relevant tile collision boxes withn (mapX, mapY)->(mapW, mapH)
    -- and return true if collision found
    for my = mapY, mapY + mapH do
        for mx = mapX, mapX + mapW do
            local tilenum = map.layers[1].data[1 + my * map.layers[1].width + mx]
            if map.collisionboxes[tilenum] then
                cblist = map.collisionboxes[tilenum]
                for k, cb in pairs(cblist) do
                    local mx1 = mx * map.tilewidth + cb.offsetX
                    local my1 = my * map.tileheight + cb.offsetY
                    local mx2 = mx1 + cb.width
                    local my2 = my1 + cb.height
                    local mapCB = {
                        x1 = mx1,
                        y1 = my1,
                        x2 = mx2,
                        y2 = my2
                    }
                    if player.checkAABBcollision(playerCB, mapCB) then
                        return true
                    end
                end
            end
        end
    end

    -- went through the whole list without detecting a collision, therefore return false
    return false
end

function player.checkAABBcollision(box1, box2)
    -- Normalize both boxes to get proper min/max
    local left1  = math.min(box1.x1, box1.x2)
    local right1 = math.max(box1.x1, box1.x2)
    local top1   = math.min(box1.y1, box1.y2)
    local bot1   = math.max(box1.y1, box1.y2)

    local left2  = math.min(box2.x1, box2.x2)
    local right2 = math.max(box2.x1, box2.x2)
    local top2   = math.min(box2.y1, box2.y2)
    local bot2   = math.max(box2.y1, box2.y2)

    -- No collision if one box is completely to the left, right, above, or below the other
    return not (
        right1 < left2 or   -- box1 is completely to the left of box2
        left1  > right2 or  -- box1 is completely to the right of box2
        bot1   < top2  or   -- box1 is completely above box2
        top1   > bot2       -- box1 is completely below box2
    )
end

-- p = player structure
-- m = map structure (for collision checking)
function player.update(p, m, dt)

    -- move player
    local newX = p.x
    local newY = p.y
    local newState = p.currentCharacter.state

    if love.keyboard.isDown("s") then
        newY = p.y + p.currentCharacter.dy * dt
        newState = "walkdown"
    elseif love.keyboard.isDown("w") then
        newY = p.y - p.currentCharacter.dy * dt
        newState = "walkup"
    elseif love.keyboard.isDown("d") then
        newX = p.x + p.currentCharacter.dx * dt
        newState = "walkright"
    elseif love.keyboard.isDown("a") then
        newX = p.x - p.currentCharacter.dx * dt
        newState = "walkleft"
    else
        if p.currentCharacter.state ~= "idle" then
            p.currentCharacter.state = "idle"
            p.currentCharacter.sprite.frame = 1
        end
    end

    -- update player state and position if not colliding with solid objects
    if (newX ~= p.x or newY ~= p.y) and not player.isColliding(p.currentCharacter.collisionBox, newX, newY, m) then
        p.x = newX
        p.y = newY
        p.currentCharacter.state = newState
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
        local state = p.currentCharacter.state
        local frame = 1
        local animCount = p.currentCharacter.sprite.animSpeed
        p.currentCharacter = p.characters[key]
        p.currentCharacter.state = state
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
    local state = p.currentCharacter.state
    local frame = p.currentCharacter.sprite.frame
    local image = p.currentCharacter.sprite.animations[state][frame]
    love.graphics.draw(image, p.x, p.y)
    -- draw effects
    love.graphics.draw(p.characterSwitchingEffect, 0, 0)
end

return player
