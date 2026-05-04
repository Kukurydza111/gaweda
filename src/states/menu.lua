statemachine = require("src/core/statemachine")

local menu = {}

function menu.load()
end

function menu.keypressed(key)
    statemachine.switch("game")
end

function menu.update(dt)
end

function menu.draw()
    love.graphics.setCanvas(glob.canvas)
    love.graphics.clear(0, 0, 0, 1)

    menu.printCentered("Gawęda", glob.titlefont, 40)
    menu.printCentered("Wciśnij jakiś klawisz, żeby zacząć grę", glob.mainfont, 200)

    love.graphics.setCanvas()
    love.graphics.draw(glob.canvas, 0, 0, 0, glob.scale, glob.scale)
end

function menu.printCentered(text, font, ypos)
    local textWidth = font:getWidth(text)
    love.graphics.print(text, font, (glob.pixelwidth - textWidth) / 2, ypos)
end

return menu