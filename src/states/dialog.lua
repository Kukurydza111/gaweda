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
        end
    end
end

function dialog.draw()
end

return dialog
