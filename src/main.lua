-- waves demo
-- by zep

r=64

function _draw()
    cls()
    for y=-r,r,3 do
        for x=-r,r,2 do
            local dist=sqrt(x*x+y*y)
            --z=cos(dist/40-t())*6
            z=sin(dist/40 - t()) + cos(dist/10 - t())
            pset(r+x,r+y-z,6)
        end
    end
end