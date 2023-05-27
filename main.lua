-- main.lua is for Love2D (https://love2d.org)

if love==nil then
  -- not using Love2D
  print("USAGE ERROR: run it with Love2D (get it at love2d.org)")
  os.exit(1)
end

local app=love -- love alias

require('common')

--------------------------------------
-- love2d.org specificities
--------------------------------------

function app.update(dt) update(dt) end

function app.draw() draw() end

function app.load()
  load()
  app.window.setTitle("")
  app.window.setMode(300,300)
end

--====================================
common API providers (love2d.org version)
--====================================

function set_draw_color(rgba)
  if not rgba then return end
  app.graphics.setColor( rgba[1], rgba[2], rgba[3], rgba[4] or 1 )
end

function draw_rectangle(xywh, rgba)
  if xywh==nil then
    xywh = { 0,0, love.graphics.getWidth(), love.graphics.getHeight() }
  end
  set_draw_color(rgba)
  app.graphics.rectangle("fill", xywh[1],xywh[2], xywh[3] or 1, xywh[4] or 1 )
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
