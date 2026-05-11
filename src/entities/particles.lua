-- Particle effects module. Uses LÖVE's ParticleSystem for burst effects.
local particles = {
    sparkImage = love.graphics.newImage("assets/images/particles/spark.png"),
    maxParticles = 100  -- pool size shared across all active particles
}

-- Creates a reusable particle system for the character-switch burst effect.
-- The system starts inactive (emissionRate=0); trigger it with triggerEffect().
function particles.newCharacterSwitchEffect()
    local sparks = love.graphics.newParticleSystem(particles.sparkImage, particles.maxParticles)

    sparks:setParticleLifetime(0.1, 0.3)    -- each spark lives 0.1–0.3 s
    sparks:setEmissionRate(0)               -- burst-only, not continuous
    sparks:setSizes(1, 0.5, 0)              -- shrinks to nothing over its lifetime
    sparks:setSpeed(50, 150)               -- random outward velocity
    sparks:setSpread(math.pi * 2)          -- full 360° spread
    sparks:setLinearAcceleration(-20, -50, 20, 50)  -- slight random drift (not gravity)
    sparks:setColors(
        1, 1, 1,    1,    -- white (birth)
        1, 0.8, 0.2, 0.8, -- yellow-orange (mid)
        1, 0.5, 0,  0     -- orange, fully transparent (death)
    )
    sparks:setRotation(0, math.pi * 2)  -- random initial sprite rotation
    sparks:setRelativeRotation(true)    -- rotation follows the velocity direction
    sparks:setSpin(-30, 30)             -- random spin speed (rad/s)

    return sparks
end

-- Fires a one-shot burst of sparks at world position (x, y).
-- count defaults to 40 if not provided.
-- Call love.graphics.draw(sparks, ...) each frame and sparks:update(dt) to animate.
function particles.triggerEffect(sparks, x, y, count)
    sparks:setPosition(x, y)
    sparks:emit(count or 40)
end


return particles
