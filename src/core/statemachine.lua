local states = {}
local currentState = {}

local stateMachine = {}

-- register a state (needs to be called only once per state)
function stateMachine.register(name, stateTable)
    states[name] = stateTable
end

-- switch to a new state (can pass data to a new state)
function stateMachine.switch(name, newStateData)
    -- if there is a leave() callback defined for current state then call it
    if currentState and currentState.leave then
        currentState.leave()
    end

    -- switch to a new state
    currentState = states[name]

    -- if there is an enter() callback defined for new state then call it
    -- and pass data to it
    if currentState and currentState.enter then
        currentState.enter(newStateData)
    end
end

--
-- Love2D callbacks forwarding for the current state
--
function stateMachine.update(dt)
    if currentState and currentState.update then
        currentState.update(dt)
    end
end

function stateMachine.draw()
    if currentState and currentState.draw then
        currentState.draw()
    end
end

function stateMachine.keypressed(key)
    if currentState and currentState.keypressed then
        currentState.keypressed(key)
    end
end
