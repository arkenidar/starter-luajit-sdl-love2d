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

function set_clip_rect(xywh)
  if xywh==nil then
    app.graphics.setScissor()
  else
    app.graphics.setScissor(xywh[1],xywh[2],xywh[3],xywh[4])
  end
end

function load_image(path)
  return app.graphics.newImage(path)
end

function draw_image(image, rect_to, rect_from)
  if rect_from==nil then
    rect_from = {0, 0, image:getWidth(), image:getHeight()}
  end
  local quad = love.graphics.newQuad(rect_from[1], rect_from[2], rect_from[3], rect_from[4], image)
  local scale_x, scale_y = rect_to[3] / rect_from[3],  rect_to[4] / rect_from[4]
  app.graphics.draw( image, quad, rect_to[1], rect_to[2], 0, scale_x, scale_y) -- ox, oy, kx, ky )
end

--====================================
