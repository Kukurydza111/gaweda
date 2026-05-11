statemachine = require("src/core/statemachine")

-- The main menu state: shows the game title and a "press any key" prompt.
local menu = {}

-- Nothing to initialize for the menu state.
function menu.load()
end

-- Any keypress transitions immediately to the game state.
function menu.keypressed(key)
    statemachine.switch("game")
end

-- No per-frame logic needed for the menu.
function menu.update(dt)
end

function menu.draw()
    -- Draw to the virtual canvas at native pixel resolution.
    love.graphics.setCanvas(glob.canvas)
    love.graphics.clear(0, 0, 0, 1)

    -- Title and prompt, both horizontally centered.
    menu.printCentered("Gawęda", glob.titlefont, 40)
    menu.printCentered("Wciśnij jakiś klawisz, żeby zacząć grę", glob.mainfont, 200)

    -- Restore default canvas and scale up to the window size.
    love.graphics.setCanvas()
    love.graphics.draw(glob.canvas, 0, 0, 0, glob.scale, glob.scale)
end

-- Draws `text` using `font` at vertical position `ypos`, centered horizontally.
function menu.printCentered(text, font, ypos)
    local textWidth = font:getWidth(text)
    love.graphics.print(text, font, (glob.pixelwidth - textWidth) / 2, ypos)
end

return menu
