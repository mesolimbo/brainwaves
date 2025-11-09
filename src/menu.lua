function menu_init()
    _update=menu_update
    _draw=menu_draw
end

function menu_update()
    if (btnp(5)) then game_init() end
end

function menu_draw()
    map(16, 0, 0, 0, 16, 16)
    print("\139 \145 to select control",23,47,10)
    print("\148 \131 to adjust control",23,67,10)
    print("adjust brainwaves to\n  cheer up monsters",23,87,10)
    print("press \151 to continue...",23,107,10)
end
