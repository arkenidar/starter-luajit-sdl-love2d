-- app.lua is for SDL2 ... (https://libsdl.org/)
-- ... via LuaJIT's FFI (https://luajit.org/)

if type(jit) ~= 'table' then
  -- not using LuaJIT
  print("USAGE ERROR: run it with LuaJIT (get it at luajit.org)")
  os.exit(1)
end

local ffi = require("ffi")
--[[
https://gist.github.com/creationix/1213280/a97d7051decb2f1d3e8844186bbff49b6442700a
-- Parse the C API header
-- It's generated with:
--
--     echo '#include <SDL.h>' > stub.c
--     gcc -I /usr/include/SDL -E stub.c | grep -v '^#' > ffi_SDL.h
--]]
ffi.cdef( io.open('ffi_defs.h','r'):read('*a') )
local SDL = ffi.load('SDL2')

SDL.SDL_Init(0)
local render_width, render_height = 300, 300
local window = SDL.SDL_CreateWindow("", 50,50, render_width,render_height, 0)
local window_surface = SDL.SDL_GetWindowSurface(window)

function rect_from_xywh(xywh)
  if xywh == nil then return nil end
  local rect = ffi.new('SDL_Rect')
  rect.x = xywh[1]
  rect.y = xywh[2]
  rect.w = xywh[3] or 1
  rect.h = xywh[4] or 1
  return rect
end
function draw_rectangle(rgb, xywh)
  rgb = {
    rgb[1]*255 ,
    rgb[2]*255 ,
    rgb[3]*255 }
  SDL.SDL_FillRect(window_surface, rect_from_xywh(xywh), SDL.SDL_MapRGB(window_surface.format,rgb[1],rgb[2],rgb[3]))
end

require('common')

load()

local time_ticks = SDL.SDL_GetTicks()

local event = ffi.new("SDL_Event")

local looping = true
while looping do

  while SDL.SDL_PollEvent(event) ~= 0 do
    if event.type == SDL.SDL_QUIT or
    ( event.type == SDL.SDL_KEYDOWN and event.key.keysym.sym == SDL.SDLK_ESCAPE ) 
    then
        looping = false
    end
  end

  if not looping then break end

  local dt -- elapsed time in fractions of seconds
  delta_ticks = SDL.SDL_GetTicks() - time_ticks
  time_ticks = SDL.SDL_GetTicks()
  dt = delta_ticks / 1000 -- milliseconds to seconds
  update(dt) -- update & draw

  draw_rectangle({0,0,0}) --clear
  draw()  
  SDL.SDL_UpdateWindowSurface(window) --present

end

SDL.SDL_DestroyWindow(window)
SDL.SDL_Quit()
