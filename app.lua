-- app.lua is for SDL2 ... (https://libsdl.org/)
-- ... via LuaJIT's FFI (https://luajit.org/)

--# pamac install luajit sdl2 sdl2_image

if type(jit) ~= 'table' then
  -- not using LuaJIT
  print("USAGE ERROR: run it with LuaJIT (get it at luajit.org)")
  os.exit(1)
end

local ffi = require("ffi")
--[[
https://gist.github.com/creationix/1213280/a97d7051decb2f1d3e8844186bbff49b6442700a
-- Parse the C API header
-- It's generated with: gcc -E ffi_defs.c | grep -v '^#' > ffi_defs.h
--]]
--[[ ffi_defs.c :
// this file name: ffi_defs.c
// gcc -E ffi_defs.c | grep -v '^#' > ffi_defs.h
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include "ffi_defs_additional.h"
--]]
ffi.cdef( io.open('ffi_defs.h','r'):read('*a') )
local SDL = ffi.load('SDL2')
local SDL_image = ffi.load('SDL2_image')
_G=setmetatable(_G, {
	__index = function(self, index) -- index function CASE
    if "SDL"==string.sub(index,1,3) then
      return SDL[index]
    end
    if "IMG"==string.sub(index,1,3) then
      return SDL_image[index]
    end
	end
})
SDL_Init(0)
local render_width, render_height = 300, 300

local window = ffi.new("SDL_Window* [1]")
local renderer = ffi.new("SDL_Renderer* [1]")
SDL_CreateWindowAndRenderer( render_width, render_height, 0, window, renderer)
window = window[0]
renderer = renderer[0]

SDL_SetRenderDrawBlendMode(renderer,SDL_BLENDMODE_BLEND)

function rect_from_xywh(xywh)
  if xywh == nil then return nil end
  local rect = ffi.new('SDL_Rect')
  rect.x = xywh[1]
  rect.y = xywh[2]
  rect.w = xywh[3] or 1
  rect.h = xywh[4] or 1
  return rect
end

--====================================
-- common API providers (luajit.org version)
--====================================

function set_draw_color(rgba)
  if not rgba then return end
  if rgba[4] == nil then rgba[4]=1 end
  rgba = {
    rgba[1]*255 ,
    rgba[2]*255 ,
    rgba[3]*255 ,
    rgba[4]*255 }
  SDL_SetRenderDrawColor( renderer, rgba[1], rgba[2], rgba[3], rgba[4] )
end

function set_draw_color_values(r,g,b,a)
  set_draw_color({r,g,b,a})
end

function draw_rectangle(xywh, rgba)
  set_draw_color(rgba)
  SDL_RenderFillRect( renderer, rect_from_xywh(xywh) )
end

function draw_rectangle_values(x,y,w,h)
  draw_rectangle({x,y,w,h})
end

function set_clip_rectangle(xywh)
  SDL_RenderSetClipRect( renderer, rect_from_xywh(xywh) )
end

function load_image(path)
  return IMG_LoadTexture(renderer, path)
end

function draw_image_to_rectangle(image, rectangle_to)
  SDL_RenderCopy(renderer, image, nil, rect_from_xywh(rectangle_to) )
end

--====================================

require('common-selector')

if app_load then app_load() end

mouse_down=false
mouse_position={0,0}

local time_ticks = SDL_GetTicks()

local event = ffi.new("SDL_Event")

local looping = true
while looping do

  while SDL_PollEvent(event) ~= 0 do
    if event.type == SDL_QUIT or
    ( event.type == SDL_KEYDOWN and event.key.keysym.sym == SDLK_ESCAPE ) 
    then
        looping = false
    elseif event.type == SDL_MOUSEBUTTONDOWN then
      mouse_down = true

    elseif event.type == SDL_MOUSEBUTTONUP then
      mouse_down = false

    elseif event.type == SDL_MOUSEMOTION then
      mouse_position = {event.button.x, event.button.y}
    end
  end

  if not looping then break end

  local dt -- elapsed time in fractions of seconds
  delta_ticks = SDL_GetTicks() - time_ticks
  time_ticks = SDL_GetTicks()
  dt = delta_ticks / 1000 -- milliseconds to seconds
  if update then update(dt) end -- update & draw

  draw_rectangle(nil, {0,0,0}) --clear
  draw()

  SDL_RenderPresent( renderer ) --present
end

SDL_DestroyRenderer( renderer )
SDL_DestroyWindow(window)
SDL_Quit()
