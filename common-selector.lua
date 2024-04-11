
-- select which?

-- love . common # require('common')
-- luajit app.lua common # require('common')

local common_file_name = love and arg[2] or arg[1] -- require(arg[1])

--print(common_file_name)

if common_file_name then require(common_file_name) ; return end

---require('common') -- first applied example for this codebase

require('common-gui-1') -- gui example from: https://github.com/arkenidar/lua-love2d/blob/main/grab-move2/main.lua
