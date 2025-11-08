function menu_init()
    _update=menu_update
    _draw=menu_draw
end

function menu_update()
    if (btnp(5)) then game_init() end
end

function menu_draw()
    print("menu!") --menu draw code
end