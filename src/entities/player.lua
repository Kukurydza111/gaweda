-- Player module: manages the player entity — movement, collision, character switching, and rendering.
-- The "player" is a container holding multiple swappable characters (Marceli, Hania, Witold, Mieszko).
particles = require("src/entities/particles")
character = require("src/entities/character")

local player = {}

-- Creates a new player instance at position (30, 100).
-- Holds a roster of 4 characters and starts as the first one (Marceli).
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
        characterSwitching = false,  -- debounce flag: prevents repeated switches while a key is held
        characterSwitchingEffect = particles.newCharacterSwitchEffect()
    }
    p.currentCharacter = p.characters[1]
    return p
end

-- Returns true if a collision box placed at (x, y) overlaps any solid tile on the map.
-- collisionBox: table with offsetX, offsetY, width, height (relative to the entity origin)
-- x, y: world-space position of the entity
-- map: map structure (tilewidth, tileheight, layers, collisionboxes)
function player.isColliding(collisionBox, x, y, map)

    -- Build the absolute world-space AABB for the player's collision box
    playerCB = {
        x1 = x + collisionBox.offsetX,
        y1 = y + collisionBox.offsetY,
        x2 = x + collisionBox.offsetX + collisionBox.width,
        y2 = y + collisionBox.offsetY + collisionBox.height
    }

    -- Find the tile coords of the top-left corner, then the span of tiles covered
    mapX = math.floor(playerCB.x1 / map.tilewidth)
    mapY = math.floor(playerCB.y1 / map.tileheight)
    mapW = math.floor(playerCB.x2 / map.tilewidth) - mapX
    mapH = math.floor(playerCB.y2 / map.tileheight) - mapY

    -- Only check tiles that the player's AABB could actually overlap, not the whole map
    for my = mapY, mapY + mapH do
        for mx = mapX, mapX + mapW do
            -- Tile data is a flat array; convert 2D tile coords to a 1-based flat index
            local tilenum = map.layers[1].data[1 + my * map.layers[1].width + mx]
            if map.collisionboxes[tilenum] then
                cblist = map.collisionboxes[tilenum]
                for k, cb in pairs(cblist) do
                    -- Convert tile-relative collision box to world-space coords
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

    return false
end

-- Standard axis-aligned bounding box overlap test.
-- box1, box2: tables with x1,y1 (one corner) and x2,y2 (opposite corner) in world coords.
-- Returns true if the two boxes overlap.
function player.checkAABBcollision(box1, box2)
    -- Normalize both boxes to proper min/max in case coords were stored in any order
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

-- Updates player state each frame.
-- p: player structure (from player.create)
-- m: map structure (used for collision checks)
-- dt: delta time in seconds
function player.update(p, m, dt)

    -- Read directional input and compute the intended new position and animation state
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
        -- No movement key held: snap back to idle and reset animation to first frame
        if p.currentCharacter.state ~= "idle" then
            p.currentCharacter.state = "idle"
            p.currentCharacter.sprite.frame = 1
        end
    end

    -- Only commit movement if the destination is clear of solid tiles
    if (newX ~= p.x or newY ~= p.y) and not player.isColliding(p.currentCharacter.collisionBox, newX, newY, m) then
        p.x = newX
        p.y = newY
        p.currentCharacter.state = newState
    end

    -- Advance the current character's animation
    character.update(p.currentCharacter, dt)

    -- Advance the particle effect (plays after a character switch)
    if p.characterSwitchingEffect then
        p.characterSwitchingEffect:update(dt)
    end

    -- Character switching: keys 1-4 select a character from the roster.
    -- characterSwitching is a debounce flag so holding a key only fires the switch once.
    local key = 0
    if love.keyboard.isDown("1") then key = 1 end
    if love.keyboard.isDown("2") then key = 2 end
    if love.keyboard.isDown("3") then key = 3 end
    if love.keyboard.isDown("4") then key = 4 end

    if key ~= 0 and p.characterSwitching == false and p.characters[key] then
        -- Carry over the current animation state so the new character enters mid-motion
        local state = p.currentCharacter.state
        local frame = 1
        local animCount = p.currentCharacter.sprite.animSpeed
        p.currentCharacter = p.characters[key]
        p.currentCharacter.state = state
        p.currentCharacter.sprite.frame = frame
        p.currentCharacter.sprite.animCount = animCount
        -- Spawn the switch particle effect roughly at the character's feet (+8x, +16y)
        particles.triggerEffect(p.characterSwitchingEffect, p.x + 8, p.y + 16, 30)
        p.characterSwitching = true
    elseif key == 0 and p.characterSwitching == true then
        -- Key released: reset debounce so the next press can trigger another switch
        p.characterSwitching = false
    end

end

-- Draws the current character sprite and any active particle effects.
function player.draw(p)
    local state = p.currentCharacter.state
    local frame = p.currentCharacter.sprite.frame
    local image = p.currentCharacter.sprite.animations[state][frame]
    love.graphics.draw(image, p.x, p.y)
    love.graphics.draw(p.characterSwitchingEffect, 0, 0)
end

return player
