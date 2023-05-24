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

function draw_rectangle(rgba, xywh)
  app.graphics.setColor( rgba[1], rgba[2], rgba[3], rgba[4] or 1 )
  app.graphics.rectangle("fill", xywh[1],xywh[2], xywh[3] or 1, xywh[4] or 1 )
end

function set_clip_rect(xywh)
  if xywh==nil then
    app.graphics.setScissor()
  else
    app.graphics.setScissor(xywh[1],xywh[2],xywh[3],xywh[4])
  end
end
