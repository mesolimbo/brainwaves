function game_init()
    _update=game_update
    _draw=game_draw
end

function game_update()
    if (btnp(5)) then menu_init() end
end

function game_draw()
    map(0, 0, 0, 0, 16, 16)
end
