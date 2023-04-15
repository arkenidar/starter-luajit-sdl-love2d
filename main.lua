-- main.lua is for Love2D (https://love2d.org)

if love==nil then
  -- not using Love2D
  print("USAGE ERROR: run it with Love2D (get it at love2d.org)")
  os.exit(1)
end

local app=love -- love alias

function app.load()
  app.window.setTitle("")
  app.window.setMode(300,300)
end

require('common')

--------------------------------------
-- love2d.org specificities
--------------------------------------

function app.update(dt) update(dt) end

function app.draw() draw() end

function draw_rectangle(rgb, xywh)
  app.graphics.setColor( rgb[1], rgb[2], rgb[3], 1 )
  app.graphics.rectangle("fill", xywh[1],xywh[2],xywh[3],xywh[4])
end
