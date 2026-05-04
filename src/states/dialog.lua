local dialog = {}

function dialog.enter(game)
    dialog.game = game
    dialog.state = "opening"
    dialog.box = {
        x_percent = 5,
        y_percent = 60,
        w_percent = 90,
        h_percent = 35,
        color = {0.1, 0.1, 0.2, 0.5}
    }
    dialog.unfold_speed = 4
    dialog.unfold_percent = 0
end

function dialog.update(dt)
    if dialog.state == "opening" then
        dialog.unfold_percent = dialog.unfold_percent + dialog.unfold_speed
        if dialog.unfold_percent >= 100 then
            dialog.unfold_percent = 100
            dialog.state = "talking"
        end
    end

    -- klawisz Q wychodzi z dialogu
    if love.keyboard.isDown("q") then
        statemachine.switch("game", nil)
    end

end

function dialog.draw()

    -- draw game as background
    dialog.game.draw()

    -- draw dialog frame

    -- target dimensions of the frame
    local x = dialog.box.x_percent * glob.pixelwidth / 100
    local y = dialog.box.y_percent * glob.pixelheight / 100
    local w = dialog.box.w_percent * glob.pixelwidth / 100
    local h = dialog.box.h_percent * glob.pixelheight / 100
    -- scale frame while entering dialog
    if dialog.state == "opening" then
        x = x + (1 - dialog.unfold_percent / 100) * (w / 2)
        w = w * dialog.unfold_percent / 100
        y = y + (1 - dialog.unfold_percent / 100) * (h / 2)
        h = h * dialog.unfold_percent / 100
    end

    love.graphics.setColor(dialog.box.color)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1, 1, 1, 1)

end

return dialog
