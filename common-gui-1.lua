-- https://github.com/arkenidar/lua-love2d/blob/main/grab-move2/main.lua

------------------------------------------------

local function point_in_rectangle(point,rectangle)
  return
    point[1]>=rectangle[1] and
    point[1]<=(rectangle[1]+rectangle[3]) and
    point[2]>=rectangle[2] and
    point[2]<=(rectangle[2]+rectangle[4])
end

------------------------------------------------

-- rettangolo sponde
local function rectangle_bounds(rectangle)
  return {rectangle[1], rectangle[2], rectangle[1]+rectangle[3], rectangle[2]+rectangle[4] }
end

-- rettangolo da sponde
local function rectangle_from_bounds(bounds)
  return {bounds[1], bounds[2], bounds[3]-bounds[1], bounds[4]-bounds[2] }
end

local function rectangle_bounds_intersect_boolean(bounds1, bounds2)
  local intersect_boolean = 
  bounds1[1] < bounds2[3] and
  bounds1[3] > bounds2[1] and
  bounds1[2] < bounds2[4] and
  bounds1[4] > bounds2[2]
  return intersect_boolean  
end

-- rettangolo operazione intersezione
-- - intersezione di 2 rettagoli -> rettangolo anche nullo : rectangle_operation_intersection
local function rectangle_operation_intersection(rectangle1, rectangle2)
  local bounds1 = rectangle_bounds(rectangle1)
  local bounds2 = rectangle_bounds(rectangle2)
  
  local intersect_boolean = rectangle_bounds_intersect_boolean(bounds1, bounds2)
  
  if not intersect_boolean then
    return nil
  end
  
  local intersection_rectangle
  local bounds3 = {
    math.max(bounds1[1], bounds2[1]),
    math.max(bounds1[2], bounds2[2]),
    math.min(bounds1[3], bounds2[3]),
    math.min(bounds1[4], bounds2[4])  
  }
  intersection_rectangle = rectangle_from_bounds(bounds3)
  return intersection_rectangle
end

------------------------------------------------

function positioning_increments(items,dx,dy)
  local x,y=items[1][1],items[1][2]
  for _,item in pairs(items) do
    item[1]=x
    item[2]=y
    x=x+dx
    y=y+dy
  end
end
--positioning_increments(handles,30,10)

function handle_grab(handle)
  local rectangle=handle
  local mouse=mouse_position
  local propagate
  if click_down==1 -- mouse just clicked
  and point_in_rectangle(mouse,rectangle) -- if inside
  then
    -- grab
    rectangle.mouse_grab_offset={mouse[1]-rectangle[1],mouse[2]-rectangle[2]}
    propagate="stop_propagation" -- grab only one
  end
  
  if rectangle.mouse_grab_offset~=nil then -- if grabbed
    rectangle[1]=mouse[1]-rectangle.mouse_grab_offset[1]
    rectangle[2]=mouse[2]-rectangle.mouse_grab_offset[2]
  end
  
  if not mouse_down then -- mouse up
    rectangle.mouse_grab_offset=nil -- un-grab
  end
  return propagate
end

function handle_draw(handle)
  local rectangle=handle
  local r,g,b=1,1,1 -- white color
  --set_draw_color{r,g,b}
  ---[[
  if rectangle.mouse_grab_offset~=nil then -- if grabbed
    --set_draw_color{1,0,0} -- red color
    r,g,b=1,0,0 -- red color
  end
  --]]
  
  --draw_rectangle{rectangle[1], rectangle[2], rectangle[3], rectangle[4]} -- rectangle
  
  set_draw_color{0.2,0.2,0.2} -- grey color (border color)
  -- rectangle (area border)
  draw_rectangle{rectangle[1], rectangle[2], rectangle[3], rectangle[4]}

  local border=5
  set_draw_color{r,g,b} -- selected color (inner color)
  -- rectangle (inner area inside the border)
  draw_rectangle{rectangle[1]+border, rectangle[2]+border, rectangle[3]-border*2, rectangle[4]-border*2}
end


------------------------------------------

function distance(x1,y1,x2,y2)
return math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
end


local function draw_formula(rectangle,connected)
local rectangle1,rectangle2 = connected[1], connected[2]
set_draw_color{0,.7,0}
--[[
local x1=150
local y1=80
local x2=50
local y2=200
--]]
local x1=rectangle1[1]+rectangle1[3]/2
local y1=rectangle1[2]+rectangle1[4]/2
local x2=rectangle2[1]+rectangle2[3]/2
local y2=rectangle2[2]+rectangle2[4]/2

  for x=rectangle[1],rectangle[1]+rectangle[3] do
    for y=rectangle[2],rectangle[2]+rectangle[4] do
      -- ellipse definition
      if (
      distance(x,y,x1,y1)+
      distance(x,y,x2,y2))<170 then
        draw_rectangle{x,y}
      end
    end
  end

end

------------------------------------------
click_down=0 -- counter for mouse button pressed
function click_get_input()
  -- click button pressing (button down)
  if mouse_down and -- button 1 down
      click_down<=500 then -- prevent integer overflow
    click_down = click_down + 1 -- increment the counter
  else -- click button release (button up)
    click_down = 0 -- reset the counter to 0
  end
end
------------------------------------------
local function button_new_formula(rectangle1, rectangle2)
  local item = {rectangle={0,0,500,500}, toggle=true, connected={rectangle1, rectangle2} }
  
  function item:action()
    if click_down==1 -- mouse just clicked
      and point_in_rectangle(mouse_position, item.rectangle) -- if inside
    then
      item.toggle = not item.toggle
    end
  end
  
  function item:draw()
    if item.toggle then draw_formula(item.rectangle, item.connected) end
  end

  return item
end

local function button_new_connecting(item_formula)
  local rectangle1, rectangle2 = item_formula.connected[1], item_formula.connected[2]
  local item = {}
  function item:draw()
    local rectangle_intersection = rectangle_operation_intersection(rectangle1, rectangle2)
    if not rectangle_intersection then return end
    set_draw_color{1,0,1,0.5}
    draw_rectangle(rectangle_intersection)
    end
  return item
end

local items
function app_load()
  local width=100
  local height=width
  --rectangle1={50,50,width,height}
  --rectangle2={150+10,50,width,height}
  --[[
  local x1=150
  local y1=80
  local x2=50
  local y2=200
  --]]
  rectangle1={150,80,width,height}
  rectangle2={50,200,width,height}
  handles={rectangle1,rectangle2,{250+20,50,width,height}}
  
  -- methods
  for _,handle in pairs(handles) do
    handle.draw=handle_draw
    handle.action=handle_grab
  end
  
  items=handles
  local item_formula = button_new_formula(handles[1], handles[2])
  table.insert(items,1, item_formula )
  table.insert(items,4, button_new_connecting(item_formula) )
end
------------------------------------------
function draw()

  -- input: click_get_input()
  click_get_input()
  
  -- input: front to back order
  for i = #items,1,-1 do
    local propagate
    if items[i].action then
    propagate=items[i]:action() end
    if propagate=="stop_propagation" then break end
  end

  -- drawing: background
  --draw_formula()

  -- drawing: back to front order
  for i = 1,#items,1 do
    if items[i].draw then
    items[i]:draw() end
  end

end
