function game_init()
    _update = game_update
    _draw = game_draw
    device = init_device()
    brainwave = init_brainwave()
    monster = init_monster()
    score = 0
    log("== Game Init ==")
end

function init_device()
    return {
        selected_control = 0,
        freq_value = 0,
        amp_value = 0,
        joy_attained = false
    }
end

function init_brainwave()
    return {
        wavelength = flr(rnd(2)) + 4,
        amplitude = flr(rnd(4)) + 1,
        tracer_pos = 0
    }
end

function init_monster()
    return {
        frame = 0,
        prev_happiness = 1,
        shake_timer = 0
    }
end

function game_update()
    handle_device_input()
    update_brainwave()
    update_monster()
    check_joy()
end

function check_joy()
    local happiness = happymeter()
    if happiness == 5 and not device.joy_attained then
        device.joy_attained = true
        score = score + 1
        log("joy attained! score: " .. score)
    end
end

function update_brainwave()
    brainwave.tracer_pos = 1 + brainwave.tracer_pos
    if brainwave.tracer_pos > 34 then
        brainwave.tracer_pos = 0
    end
end

function update_monster()
    -- Increment frame counter for bobbing animation
    monster.frame = monster.frame + 1

    -- Check if happiness changed
    local current_happiness = happymeter()
    if current_happiness != monster.prev_happiness then
        monster.shake_timer = 15 -- Shake for 15 frames
        monster.prev_happiness = current_happiness
    end

    -- Decrement shake timer
    if monster.shake_timer > 0 then
        monster.shake_timer = monster.shake_timer - 1
    end
end

function happymeter()
    local freq_diff = abs(device.freq_value - brainwave.wavelength)
    local amp_diff = abs(device.amp_value - brainwave.amplitude)
    local distance = sqrt(freq_diff * freq_diff + amp_diff * amp_diff)
    local max_distance = sqrt(5 * 5 + 4 * 4)
    local normalized = 1 - (distance / max_distance)
    local happiness = flr(normalized * 4) + 1

    return max(1, min(5, happiness))
end

function handle_device_input()
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
    local slider_changed = false
    if btnp(2) then -- Up
        if device.selected_control == 0 then
            device.freq_value = min(5, device.freq_value + 1)
            slider_changed = true
        elseif device.selected_control == 1 then
            device.amp_value = min(5, device.amp_value + 1)
            slider_changed = true
        end
    elseif btnp(3) then -- Down
        if device.selected_control == 0 then
            device.freq_value = max(0, device.freq_value - 1)
            slider_changed = true
        elseif device.selected_control == 1 then
            device.amp_value = max(0, device.amp_value - 1)
            slider_changed = true
        end
    end

    -- Log values when slider changes
    if slider_changed then
        local happiness = happymeter()
        log("sliders   - freq: " .. device.freq_value .. " amp: " .. device.amp_value)
        log("brainwave - freq: " .. brainwave.wavelength .. " amp: " .. brainwave.amplitude)
        log("happiness: " .. happiness)
    end

    -- O button: Skip when skip button is selected
    if btnp(4) and device.selected_control == 2 then
        -- Reset device and brainwave, but keep score
        device = init_device()
        brainwave = init_brainwave()
        monster = init_monster()
    end
end

function game_draw()
    map(0, 0, 0, 0, 16, 16)
    draw_brainwave()

    -- Draw happiness meter (moves up 5 pixels per happiness level)
    local happiness = happymeter()
    local meter_y1 = 101 - (happiness - 1) * 5
    local meter_y2 = 104 - (happiness - 1) * 5

    -- Color changes: red(8) -> orange(9) -> yellow(10) -> green(11) -> blue(12)
    local colors = {8, 9, 10, 11, 12}
    local meter_color = colors[happiness]

    rectfill(112, meter_y1, 114, meter_y2, meter_color)

    -- Calculate slider positions (base y=119, move up 8 pixels per level)
    local freq_y = 119 - (device.freq_value * 8)
    local amp_y = 119 - (device.amp_value * 8)

    -- Draw slider sprites
    spr(48, 25, freq_y)
    spr(48, 49, amp_y)

    -- Highlight selected control
    if device.selected_control == 0 then
        rect(24, freq_y - 1, 32, freq_y + 3, 14) -- Highlight Freq control
    elseif device.selected_control == 1 then
        rect(48, amp_y - 1, 56, amp_y + 3, 14) -- Highlight Amp control
    elseif device.selected_control == 2 then
        spr(99, 64, 88, 3, 2) -- Highlight Skip button
    end

    draw_monster()
    draw_score()
end

function draw_brainwave()
    local y_start = 30
    local y_end = 59

    for y = y_start, y_end do
        draw_brain_scan(y, y_start, y_end, 14)
    end

    local tracer_start = flr(brainwave.tracer_pos)
    for i = 0, 3 do
        local tracer_y = y_start + tracer_start - i
        if tracer_y >= y_start and tracer_y <= y_end then
            draw_brain_scan(tracer_y, y_start, y_end, 2)
        end
    end
end

function draw_brain_scan(y, y_start, y_end, color)
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

    for _ = 1, 5 - #score_str do
        padded_score = padded_score .. "0"
    end
    padded_score = padded_score .. score_str
    print("score: " .. padded_score, 68, 118, 12)
end

function draw_monster()
    local happiness = happymeter()

    -- Calculate bobbing offset (gentle up and down motion)
    local bob_offset = sin(monster.frame / 30) * 1.5

    -- Calculate shake offset (small random movements when mood changes)
    local shake_x = 0
    local shake_y = 0
    if monster.shake_timer > 0 then
        shake_x = (rnd(2) - 1) * 2
        shake_y = (rnd(2) - 1) * 2
    end

    -- Base position
    local base_x = 34
    local base_y = 34

    -- Apply offsets
    local x = base_x + shake_x
    local y = base_y + bob_offset + shake_y

    -- Always draw base (Mad, happiness 1)
    spr(70, x, y, 3, 3)

    if happiness == 2 then
        spr(76, x, y + 8, 3, 2) -- Fear
    elseif happiness == 3 then
        spr(73, x, y + 8, 3, 2) -- Sad
    elseif happiness == 4 then
        spr(105, x, y + 8, 3, 2) -- Shy
    elseif happiness == 5 then
        spr(108, x, y + 8, 3, 2) -- Joy
    end
end
