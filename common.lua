-- common.lua is the core app common to app.lua and main.lua
-- common API is: update, draw, draw_rectangle

-- animation 1
local intensity = 1
local angle= 90

-- animation 2
local x = 0

-- https://love2d.org/wiki/love.update
function update(dt)
  
  -- animation 1
  local increment = 45*dt -- degrees
  angle = angle + increment
  while angle>360 do angle=angle-360 end -- circle
  local radiants = angle/360*math.pi*2
  intensity= math.abs(math.sin(radiants))
  
  -- animation 2
  local increment_x = 100*dt
  x = ( x + increment_x ) % 300
end

-- https://love2d.org/wiki/love.draw
function draw()
  
  -- animation 1
  draw_rectangle({intensity,1-intensity,0}, {10+40*intensity,50,200,100})
  
  -- animation 2
  draw_rectangle({1,1,0}, {x,250,50,5})
end
