function game_init()
    _update = game_update
    _draw = game_draw
    device = init_device()
    brainwave = init_brainwave()
    score = 0
end

function init_device()
    return {
        selected_control = 0, -- 0=freq, 1=amp, 2=skip button
        freq_value = 0,       -- 0-4
        amp_value = 0         -- 0-4
    }
end

function init_brainwave()
    return {
        wavelength = flr(rnd(2)) + 4,
        amplitude = flr(rnd(4)) + 1,
        tracer_pos = 0
    }
end

function game_update()
    handle_device_input()
    update_brainwave()
end

function handle_device_input()
    -- Left/Right: Navigate between controls
    if btnp(0) then -- Left
        device.selected_control = device.selected_control - 1
        if device.selected_control < 0 then
            device.selected_control = 2
        end
    elseif btnp(1) then -- Right
        device.selected_control = device.selected_control + 1
        if device.selected_control > 2 then
            device.selected_control = 0
        end
    end

    -- Up/Down: Adjust slider values
    if btnp(2) then -- Up
        if device.selected_control == 0 then
            device.freq_value = min(4, device.freq_value + 1)
        elseif device.selected_control == 1 then
            device.amp_value = min(4, device.amp_value + 1)
        end
    elseif btnp(3) then -- Down
        if device.selected_control == 0 then
            device.freq_value = max(0, device.freq_value - 1)
        elseif device.selected_control == 1 then
            device.amp_value = max(0, device.amp_value - 1)
        end
    end

    -- X/O: Activate skip button or return to menu
    if btnp(4) or btnp(5) then
        if device.selected_control == 2 then
            -- Skip button pressed - add your skip logic here
            -- For now, return to menu
            menu_init()
        end
    end
end

function update_brainwave()
    brainwave.tracer_pos = 1 + brainwave.tracer_pos
    if brainwave.tracer_pos > 34 then
        brainwave.tracer_pos = 0
    end
end

function game_draw()
    map(0, 0, 0, 0, 16, 16)
    draw_brainwave()
    rectfill(112, 101, 114, 104, 8)

    spr(48, 25, 119)
    spr(48, 49, 119)

    -- Highlight selected control
    if device.selected_control == 0 then
        rect(24, 118, 32, 122, 14) -- Highlight Freq control
    elseif device.selected_control == 1 then
        rect(48, 118, 56, 122, 14) -- Highlight Amp control
    elseif device.selected_control == 2 then
        spr(99, 64, 88, 3, 2) -- Highlight Skip button
    end

    draw_score()
end

function draw_brainwave()
    local y_start = 30
    local y_end = 59

    for y = y_start, y_end do
        plot_brainwave(y, y_start, y_end, 14)
    end

    local tracer_start = flr(brainwave.tracer_pos)
    for i = 0, 3 do
        local tracer_y = y_start + tracer_start - i
        if tracer_y >= y_start and tracer_y <= y_end then
            plot_brainwave(tracer_y, y_start, y_end, 2)
        end
    end
end

function plot_brainwave(y, y_start, y_end, color)
    local x_center = 104
    local x_range = 3.5
    local total_height = y_end - y_start
    local t = (y - y_start) / total_height
    local angle = t * brainwave.wavelength * 3.14159 * 2
    local sine_value = sin(angle)
    local x = x_center + (sine_value * brainwave.amplitude * x_range / 4)

    pset(x, y, color)
end

function draw_score()
    local padded_score = ""
    local score_str = tostring(score)

    for i = 1, 5 - #score_str do
        padded_score = padded_score .. "0"
    end
    padded_score = padded_score .. score_str
    print("score: " .. padded_score, 68, 118, 12)
end
