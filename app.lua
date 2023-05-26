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
-- It's generated with: gcc -E ffi_defs.c | grep -v '^#' > ffi_defs.h
--[[ ffi_defs.c :
// this file name: ffi_defs.c
// gcc -E ffi_defs.c | grep -v '^#' > ffi_defs.h
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include "ffi_defs_additional.h"
--]]
ffi.cdef( io.open('ffi_defs.h','r'):read('*a') )
local SDL = ffi.load('SDL2')

SDL.SDL_Init(0)
local render_width, render_height = 300, 300

local window = ffi.new("SDL_Window* [1]")
local renderer = ffi.new("SDL_Renderer* [1]")
SDL.SDL_CreateWindowAndRenderer( render_width, render_height, 0, window, renderer)
window = window[0]
renderer = renderer[0]

SDL.SDL_SetRenderDrawBlendMode(renderer,SDL.SDL_BLENDMODE_BLEND)

function rect_from_xywh(xywh)
  if xywh == nil then return nil end
  local rect = ffi.new('SDL_Rect')
  rect.x = xywh[1]
  rect.y = xywh[2]
  rect.w = xywh[3] or 1
  rect.h = xywh[4] or 1
  return rect
end

function set_draw_color(rgba)
  if not rgba then return end
  if rgba[4] == nil then rgba[4]=1 end
  rgba = {
    rgba[1]*255 ,
    rgba[2]*255 ,
    rgba[3]*255 ,
    rgba[4]*255 }
  SDL.SDL_SetRenderDrawColor( renderer, rgba[1], rgba[2], rgba[3], rgba[4] )
end

function draw_rectangle(xywh, rgba)
  set_draw_color(rgba)
  SDL.SDL_RenderFillRect( renderer, rect_from_xywh(xywh) )
end

function set_clip_rect(xywh)
  SDL.SDL_RenderSetClipRect( renderer, rect_from_xywh(xywh) )
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

  draw_rectangle(nil, {0,0,0}) --clear
  draw()

  SDL.SDL_RenderPresent( renderer ) --present
end

SDL.SDL_DestroyRenderer( renderer )
SDL.SDL_DestroyWindow(window)
SDL.SDL_Quit()
