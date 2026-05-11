-- Dialog state: shown when the player interacts with an NPC or trigger.
-- Renders the game world in the background, then overlays a dialog box.
-- Transitions: opening -> talking (box finishes unfolding) -> (Q key) -> game
local dialog = {}

function dialog.enter(game)
    dialog.game = game          -- reference to the game state, used to draw the background
    dialog.state = "opening"    -- start with the unfolding animation

    -- box position and size defined as percentages of screen, so it scales with any resolution
    dialog.box = {
        x_percent = 5,
        y_percent = 60,
        w_percent = 90,
        h_percent = 35,
        color = {0.1, 0.1, 0.2, 0.5}
    }

    dialog.unfold_speed = 10    -- percent of box revealed per frame at 60 fps
    dialog.unfold_percent = 0   -- starts fully collapsed; reaches 100 when fully open
end

function dialog.update(dt)
    if dialog.state == "opening" then
        -- advance the unfold animation; multiply by 60 so speed is frame-rate-independent
        dialog.unfold_percent = dialog.unfold_percent + dialog.unfold_speed * 60 * dt
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
    -- draw game world as background behind the dialog
    dialog.game.draw()

    -- convert percent-based layout to pixel coordinates
    local x = dialog.box.x_percent * glob.pixelwidth / 100
    local y = dialog.box.y_percent * glob.pixelheight / 100
    local w = dialog.box.w_percent * glob.pixelwidth / 100
    local h = dialog.box.h_percent * glob.pixelheight / 100

    -- during opening, shrink the box towards its center so it appears to unfold outward:
    -- offset x/y inward by half the missing width/height, then scale w/h by the current percent
    if dialog.state == "opening" then
        x = x + (1 - dialog.unfold_percent / 100) * (w / 2)
        w = w * dialog.unfold_percent / 100
        y = y + (1 - dialog.unfold_percent / 100) * (h / 2)
        h = h * dialog.unfold_percent / 100
    end

    love.graphics.setColor(dialog.box.color)
    love.graphics.rectangle("fill", x, y, w, h)
    love.graphics.setColor(1, 1, 1, 1)  -- reset color so nothing else is tinted
end

return dialog
