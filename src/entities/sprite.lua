local sprite = {}

function sprite.load(spriteName)
    local newSprite = {
        name = spriteName,
        animations = {},
        state = "idle",
        frame = 1,
        animSpeed = 20,
        animCount = 20
    }

    local directory = "assets/images/sprites/" .. spriteName
    local files = love.filesystem.getDirectoryItems(directory)
    
    for _, filename in ipairs(files) do

        if filename:match("%.png$") then

            local animName, frameStr = filename:match("(.+)_(%d+)%.png$")
            
            if animName and frameStr then
                local frameNum = tonumber(frameStr)
                
                if not newSprite.animations[animName] then
                    newSprite.animations[animName] = {}
                end
                
                local imagePath = directory .. "/" .. filename
                newSprite.animations[animName][frameNum] = love.graphics.newImage(imagePath)
            else
                print("sprite.load: Could not parse filename: " .. filename)
            end
        end
    end
    
    for animName, frames in pairs(newSprite.animations) do
        local maxFrame = 0
        for f in pairs(frames) do
            if f > maxFrame then maxFrame = f end
        end
        
        for i = 1, maxFrame do
            if not frames[i] then
                print("sprite.load: Missing frame " .. i .. " for animation '" .. animName .. "'")
            end
        end
    end

    return newSprite
end

function sprite.update(s, dt)
    -- animacja sprite'a
    if s.animCount <= 0 then
        -- next frame
        s.frame = s.frame + 1
        if s.frame > #s.animations[s.state] then
            s.frame = 1
        end
        -- reset anim speed counter
        s.animCount = s.animSpeed
    else
        -- reduce anim speed counter
        s.animCount = s.animCount - 1
    end
end

return sprite
