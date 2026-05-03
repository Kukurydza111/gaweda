local particles = {
    sparkImage = love.graphics.newImage("assets/images/particles/spark.png"),
    maxParticles = 100
}

function particles.newCharacterSwitchEffect()
    local sparks = love.graphics.newParticleSystem(particles.sparkImage, particles.maxParticles)

    sparks:setParticleLifetime(0.1, 0.3)
    sparks:setEmissionRate(0)
    sparks:setSizes(1, 0.5, 0)
    sparks:setSpeed(50, 150)
    sparks:setSpread(math.pi * 2)
    sparks:setLinearAcceleration(-20, -50, 20, 50)
    sparks:setColors(
        1, 1, 1, 1,
        1, 0.8, 0.2, 0.8,
        1, 0.5, 0, 0
    )
    sparks:setRotation(0, math.pi * 2)
    sparks:setRelativeRotation(true)
    sparks:setSpin(-30, 30)

    return sparks
end

function particles.triggerEffect(sparks, x, y, count)
    sparks:setPosition(x, y)
    sparks:emit(count or 40)
end


return particles
