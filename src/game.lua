function game_init()
    _update=game_update
    _draw=game_draw
    brainwave = init_brain()
end

function init_brain()
    local brain = {}
    brain.wavelength = flr(rnd(2)) + 4  -- Random integer from 1-5
    brain.amplitude = flr(rnd(4)) + 1   -- Random integer from 2-4
    brain.tracer_pos = 0
    return brain
end

function game_update()
    if (btnp(5)) then menu_init() end
    update_brainwave()
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
end

function draw_brainwave()
    local y_start = 30
    local y_end = 59

    for y = y_start, y_end do
        plot_wave(y, y_start, y_end, 14)
    end

    local tracer_start = flr(brainwave.tracer_pos)
    for i = 0, 3 do
        local tracer_y = y_start + tracer_start - i
        if tracer_y >= y_start and tracer_y <= y_end then
            plot_wave(tracer_y, y_start, y_end, 2)
        end
    end
end

function plot_wave(y, y_start, y_end, color)
    local x_center = 104
    local x_range = 3.5
    local total_height = y_end - y_start
    local t = (y - y_start) / total_height
    local angle = t * brainwave.wavelength * 3.14159 * 2
    local sine_value = sin(angle)
    local x = x_center + (sine_value * brainwave.amplitude * x_range / 4)

    pset(x, y, color)
end
