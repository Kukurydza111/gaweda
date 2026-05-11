-- State machine module for managing game states (e.g. menu, gameplay, dialog).
-- Usage:
--   1. Call stateMachine.register(name, stateTable) once per state at startup.
--   2. Call stateMachine.switch(name, data) to transition between states.
--   3. Forward Love2D callbacks (update, draw, keypressed) to this module from main.lua
--      so the active state receives them automatically.
--
-- Each stateTable can define any of these callback functions:
--   load()           -- called once when the state is registered (for one-time setup)
--   enter(data)      -- called every time this state becomes active; receives optional data
--   leave()          -- called just before leaving this state
--   update(dt)       -- called every frame with the delta time
--   draw()           -- called every frame for rendering
--   keypressed(key)  -- called when a key is pressed

local states = {}        -- table of all registered states, keyed by name
local currentState = {}  -- reference to the currently active state table

local stateMachine = {}

-- Register a state under a given name.
-- Calls stateTable.load() immediately if defined (one-time initialisation).
function stateMachine.register(name, stateTable)
    states[name] = stateTable
    if stateTable.load then
        stateTable.load()
    end
end

-- Transition to the state with the given name.
-- Calls leave() on the current state, then enter(newStateData) on the new one.
function stateMachine.switch(name, newStateData)
    if currentState and currentState.leave then
        currentState.leave()
    end

    currentState = states[name]

    if currentState and currentState.enter then
        currentState.enter(newStateData)
    end
end

-- Forward Love2D callbacks to the active state.
-- Call these from the matching love.* functions in main.lua.

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

return stateMachine
