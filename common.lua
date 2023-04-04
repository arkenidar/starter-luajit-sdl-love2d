-- common.lua is the core app common to app.lua and main.lua
-- common API is: update, draw, draw_rectangle

local intensity = 1
local angle= 90

-- https://love2d.org/wiki/love.update
function update(dt)
  local increment = 45*dt -- degrees
  angle = angle + increment
  while angle>360 do angle=angle-360 end -- circle
  local radiants = angle/360*math.pi*2
  intensity= math.abs(math.sin(radiants))
end

-- https://love2d.org/wiki/love.draw
function draw()
  draw_rectangle({intensity,1-intensity,0}, {10+40*intensity,50,200,100})
end
