
-- select which?

local common_file_name = arg[1] -- require(arg[1])

--print(common_file_name)

if common_file_name then require(common_file_name) ; return end

---require('common') -- first applied example for this codebase

require('common-gui-1') -- gui example from: https://github.com/arkenidar/lua-love2d/blob/main/grab-move2/main.lua
