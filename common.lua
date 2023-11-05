--[[
"common.lua" is the core app common to "app.lua" (luajit.org) and "main.lua" (love2d.org).
common API is:
  app_load, update, draw,
  set_draw_color,
  draw_rectangle, set_clip_rectangle,
  load_image, draw_image_to_rectangle
--]]

--# pamac install luajit sdl2 sdl2_image love

-- https://love2d.org/wiki/love.load
function app_load()
  print("app console")

  -- OPTIONAL: luasocket for LuaJIT, i.e. Lua 5.1 (LuaJIT internally is 5.1, mostly)
  -- sudo luarocks install luasocket
  --[[
  pamac install lua51 luarocks
  sudo luarocks --lua-version 5.1 install luasocket
  luarocks --lua-version 5.1 show luasocket
  --]]
  --- local socket=require("socket") -- love2d bundles this already, luajit not by default
  print("(optional) socket support")

  image1 = load_image("assets/horse.png")
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
  local increment_x = 50*dt
  anim1_x = anim1_x + increment_x
  if anim1_x > screen_width then anim1_x = -anim_width+(anim1_x%screen_width) end
  
  -- animation 2
  anim2_x = anim2_x + increment_x
  local anim2_width = rectangle1_width ---screen_width
  if anim2_x > anim2_width then anim2_x = -anim_width+(anim2_x%anim2_width) end
  
end

-- https://love2d.org/wiki/love.draw
function draw()

  draw_rectangle(nil, {173/255, 67/255, 121/255 }) --clear

  -- back-ground ellipse formula drawing
  formula_draw()

  -- animation 0a
  local rectangle1_xywh = {10+40*pulsation_intensity,50,rectangle1_width,150}

  -- draw image
  draw_image_to_rectangle(image1, rectangle1_xywh)

  -- animation 0b
  draw_rectangle(rectangle1_xywh, {pulsation_intensity,1-pulsation_intensity,0, 0.5})

  -- animation 1a
  draw_rectangle({anim1_x,100,anim_width,5}, {1,1,0})

  -- animation 1b
  set_clip_rectangle(rectangle1_xywh)
  draw_rectangle({anim1_x,100+25,anim_width,5}, {1,1,0})
  set_clip_rectangle()
  
  -- animation 2
  --set_clip_rectangle(rectangle1_xywh)
  local rect_inside_x = anim2_x+rectangle1_xywh[1]
  local x_from, x_to = rect_inside_x, rect_inside_x+anim_width
  x_from = math.max(x_from , rectangle1_xywh[1])
  x_to = math.min(x_to , rectangle1_xywh[1]+rectangle1_xywh[3] )
  draw_rectangle({ x_from , 100+50 , x_to-x_from , 5 }, {0,0,1})
  --set_clip_rectangle()

  sliders_draw()

  -- rectangle under mouse
  local x,y,pressed = mouse_position[1],mouse_position[2],mouse_down
  local size = 15
  draw_rectangle({ x-size/2 , y-size/2 , size , size }, {1,0,1})

end

function formula_draw()
  local x1=150
  local y1=180
  local x2=50
  local y2=300

  for x=0,500 do
      for y=0,500 do
          -- ellipse definition
          if (
          2*distance(x,y,x1,y1)+
          distance(x,y,x2,y2))<300 then
          ---love.graphics.points({ {x,y} })
          draw_rectangle({x,y}, {0,0,1})
          end
      end
  end
end

function distance(x1,y1,x2,y2)
  return math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
end

local sliders_left=150
local sliders_top=10
local sliders={
  --        x,            y                 width,height  value color
  red =    {sliders_left, sliders_top+60*0, 100,50,       0.75, {1,0,0}},
  green =  {sliders_left, sliders_top+60*1, 100,50,       0.75, {0,1,0}},
  blue =   {sliders_left, sliders_top+60*2, 100,50,       0.75, {0,0,1}},
  alpha =  {sliders_left, sliders_top+60*3, 100,50,       0.75, {0,0,0}},
}

function sliders_draw()
  slider_draw(sliders.red)
  slider_draw(sliders.green)
  slider_draw(sliders.blue)
  slider_draw(sliders.alpha)

  -- item colored with given values
  local item_color = {sliders.red[5],sliders.green[5],sliders.blue[5],sliders.alpha[5]}
  set_draw_color({item_color[1],item_color[2],item_color[3],item_color[4]}) -- colored item
  draw_rectangle({10,sliders_top+0, 50,50}) -- xywh
  set_draw_color({1,1,1}) -- reset to white
end


function slider_value_update(slider)
  local x,y,pressed = mouse_position[1],mouse_position[2],mouse_down
  local slider_handle_width=50
  if pressed and
    -- inside slider check
    x>=(slider[1]-slider_handle_width) and
      x<=(slider[1]+slider[3]+slider_handle_width) and
    y>=slider[2] and y<=(slider[2]+slider[4])
  then
    -- slider value
    slider[5] = (x-slider[1])/slider[3]
    -- clamp it [0..1]
    slider[5] = math.min(slider[5],1) -- max 1
    slider[5] = math.max(slider[5],0) -- min 0
  end
end

function slider_draw(slider)

  -- slider update
  slider_value_update(slider)

  -- slider draw
  local slider_handle_width=10
  -- background
  set_draw_color({1,1,1,0.3}) -- white bg
  draw_rectangle({slider[1], slider[2], slider[3]+slider_handle_width, slider[4]}) -- xywh
  -- slider
  local slider_color=slider[6]
  set_draw_color({slider_color[1],slider_color[2],slider_color[3]}) -- colored slider
  local sliderx=slider[1]+slider[5]*slider[3]
	draw_rectangle({sliderx,slider[2], slider_handle_width,slider[4]}) -- xywh
end
