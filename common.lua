-- common.lua is the core app common to app.lua and main.lua
-- common API is: update, draw, draw_rectangle

-- animation 1
local pulsation_intensity = 1
local pulsation_angle= 90

-- animation 2
local anim_x = 0
local anim_width = 50
local screen_width = 300

-- https://love2d.org/wiki/love.update
function update(dt)
  
  -- animation 1
  local increment = 45*dt -- degrees
  pulsation_angle = pulsation_angle + increment
  while pulsation_angle>360 do pulsation_angle=pulsation_angle-360 end -- circle
  local radiants = pulsation_angle/360*math.pi*2
  pulsation_intensity= math.abs(math.sin(radiants))
  
  -- animation 2
  local increment_x = 100*dt
  anim_x = anim_x + increment_x
  if anim_x > screen_width then anim_x = -anim_width+(anim_x%screen_width) end
end

-- https://love2d.org/wiki/love.draw
function draw()
  
  -- animation 1
  draw_rectangle({pulsation_intensity,1-pulsation_intensity,0}, {10+40*pulsation_intensity,50,200,100})
  
  -- animation 2
  draw_rectangle({1,1,0}, {anim_x,250,anim_width,5})
end
