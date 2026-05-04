local dialog = {}

function dialog.enter(dialogData)
    dialog.current = dialogData
    dialog.state = "opening"
    dialog.box = {
        x_percent = 10,
        y_percent = 60,
        w_percent = 80,
        h_percent = 30,
        color = {0.7, 0.7, 1, 0.5},
        unfold_speed = 4,
        unfold_percent = 0
    }
end

function dialog.update(dt)
    if dialog.state == "opening" then
        dialog.box.unfold_percent = dialog.box.unfold_percent + dialog.box.unfold_speed
        if dialog.box.unfold_percent >= 100 then
            dialog.box.unfold_percent = 100
            dialog.state = "talking"
        end
    end

    -- klawisz Q wychodzi z dialogu
    if love.keyboard.isDown("q") then
        statemachine.switch("game", nil)
    end

end

function dialog.draw()
    -- draw dialog background
    local x = dialog.box.x_percent * glob.pixelwidth / 100
    local y = dialog.box.y_percent * glob.pixelheight / 100
    local w = dialog.box.w_percent * glob.pixelwidth / 100
    local h = dialog.box.h_percent * glob.pixelheight / 100
    love.graphics.setColor(dialog.box.color)
    love.graphics.rectangle("fill", x, y, w, h)
end

return dialog
