function menu_init()
    _update=menu_update
    _draw=menu_draw
end

function menu_update()
    if (btnp(5)) then game_init() end
end

function menu_draw()
    map(16, 0, 0, 0, 16, 16)
    map(16, 0, 0, 0, 16, 16)
    print("\139 \145 to select control",18,47,10)
    print("\148 \131 to adjust control",18,57,10)
    print("\142 to press control",30,67,10)
    print("adjust brainwaves to\n   cheer up aliens",23,84,10)
    print("press \151 to continue...",18,107,10)
end
