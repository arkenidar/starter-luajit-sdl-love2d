-- main.lua is for Love2D (https://love2d.org)

--# pamac install love

if love==nil then
  -- not using Love2D
  print("USAGE ERROR: run it with Love2D (get it at love2d.org)")
  os.exit(1)
end

local app=love -- love alias

require('common-selector')

--------------------------------------
-- love2d.org specificities
--------------------------------------

mouse_down = false
mouse_position = {0,0}

function app.update(dt)
  mouse_down = app.mouse.isDown(1)
  mouse_position = {app.mouse.getX(), app.mouse.getY()}
  if update then update(dt) end
end

function app.draw() draw() end

function app.load()
  if app_load then app_load() end
  app.window.setTitle("")
  app.window.setMode(300,300)
end

--====================================
-- common API providers (love2d.org version)
--====================================

function set_draw_color(rgba)
  if not rgba then return end
  app.graphics.setColor( rgba[1], rgba[2], rgba[3], rgba[4] or 1 )
end

function set_draw_color_values(r,g,b,a)
  set_draw_color({r,g,b,a})
end

function draw_rectangle(xywh, rgba)
  if xywh==nil then
    xywh = { 0,0, app.graphics.getWidth(), app.graphics.getHeight() }
  end
  set_draw_color(rgba)
  app.graphics.rectangle("fill", xywh[1],xywh[2], xywh[3] or 1, xywh[4] or 1 )
end

function draw_rectangle_values(x,y,w,h)
  draw_rectangle({x,y,w,h})
end

function set_clip_rectangle(xywh)
  if xywh==nil then
    app.graphics.setScissor()
  else
    app.graphics.setScissor(xywh[1],xywh[2],xywh[3],xywh[4])
  end
end

function load_image(path)
  return app.graphics.newImage(path)
end

function draw_image_to_rectangle(image, rectangle_to)
  local position_x, position_y = rectangle_to[1], rectangle_to[2]
  local scale_x = rectangle_to[3]/image:getWidth()
  local scale_y = rectangle_to[4]/image:getHeight()
  app.graphics.draw( image, position_x, position_y, 0, scale_x, scale_y)
end

--====================================
