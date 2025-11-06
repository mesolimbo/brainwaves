-- waves demo
-- by zep

function _draw()
    map(0, 0, 0, 0, 16, 16)
end
--r=64-8  -- 8 pixel border
--
--function _draw()
--    map(0, 0, 0, 0, 16, 16)  -- draw the map as background
--    for y=-r,r,3 do
--        for x=-r,r,2 do
--            local dist=sqrt(x*x+y*y)
--            --z=cos(dist/40-t())*6
--            z=sin(dist/40 - t()) + cos(dist/10 - t())
--            pset(64+x,64+y-z,10)  -- center at screen center (64, 64)
--        end
--    end
--end