-- Sprite module: loads and animates 2D sprites from frame-based PNG files.
-- Expected file naming: assets/images/sprites/<name>/<animName>_<frameNum>.png
-- Example: assets/images/sprites/player/walk_1.png, walk_2.png, ...
local sprite = {}

-- Loads all animations for a sprite from disk.
-- Scans the sprite's directory, parses filenames into animation tables keyed
-- by animation name, with frame images stored at their frame index.
-- Also warns about any gaps in frame sequences.
function sprite.load(spriteName)
    local newSprite = {
        name = spriteName,
        animations = {},  -- { [animName] = { [frameNum] = Image, ... }, ... }
        frame = 1,        -- current frame index within the active animation
        animSpeed = 7,    -- how many ticks each frame is displayed
        animCount = 7     -- countdown timer; advances frame when it reaches 0
    }

    local directory = "assets/images/sprites/" .. spriteName
    local files = love.filesystem.getDirectoryItems(directory)

    for _, filename in ipairs(files) do

        if filename:match("%.png$") then
            -- Parse "animName_frameNum.png" from the filename
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

    -- Validate that each animation has no missing frames (e.g. walk_1, walk_3
    -- with no walk_2 would leave a nil hole that crashes during playback).
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

-- Advances the sprite's animation frame based on elapsed time.
-- `state` is the current animation name (must exist in s.animations).
-- Uses a countdown counter so each frame is shown for `animSpeed` ticks
-- regardless of frame rate.
function sprite.update(s, state, dt)
    if s.animCount <= 0 then
        s.frame = s.frame + 1
        if s.frame > #s.animations[state] then
            s.frame = 1  -- loop back to the first frame
        end
        s.animCount = s.animSpeed  -- reset the per-frame tick counter
    else
        s.animCount = s.animCount - 60 * dt  -- deplete counter at 60-tick/s rate
    end
end

return sprite
