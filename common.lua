-- common.lua is the core app common to app.lua and main.lua
-- common API is: load, update, draw, draw_rectangle

-- https://love2d.org/wiki/love.load
function load()
  print("app console")
end

-- animation 0
local pulsation_intensity = 1
local pulsation_angle= 90

-- animation 1 and 2
local anim1_x, anim2_x = 0, 0 
local anim_width = 50
local screen_width = 300
local rectangle1_width = 200

-- https://love2d.org/wiki/love.update
function update(dt)
  
  -- animation 0
  local increment = 45*dt -- degrees
  pulsation_angle = pulsation_angle + increment
  while pulsation_angle>360 do pulsation_angle=pulsation_angle-360 end -- circle
  local radiants = pulsation_angle/360*math.pi*2
  pulsation_intensity= math.abs(math.sin(radiants))
  
  -- animation 1a, 1b
  local increment_x = 10*dt
  anim1_x = anim1_x + increment_x
  if anim1_x > screen_width then anim1_x = -anim_width+(anim1_x%screen_width) end
  
  -- animation 2
  anim2_x = anim2_x + increment_x
  local anim2_width = rectangle1_width ---screen_width
  if anim2_x > anim2_width then anim2_x = -anim_width+(anim2_x%anim2_width) end
  
end

-- https://love2d.org/wiki/love.draw
function draw()
  
  -- animation 0
  local rectangle1_xywh = {10+40*pulsation_intensity,50,rectangle1_width,150}
  draw_rectangle({pulsation_intensity,1-pulsation_intensity,0}, rectangle1_xywh)
  
  -- animation 1a
  draw_rectangle({1,1,0}, {anim1_x,100,anim_width,5})

  -- animation 1b
  set_clip_rect(rectangle1_xywh)
  draw_rectangle({1,1,0}, {anim1_x,100+25,anim_width,5})
  set_clip_rect()
  
  -- animation 2
  set_clip_rect(rectangle1_xywh)
  draw_rectangle({0,0,1}, {anim2_x+rectangle1_xywh[1],100+50,anim_width,5})
  set_clip_rect()

end
