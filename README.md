# starter-luajit-sdl-love2d
basic starter example common with main.lua and app.lua layers (so you can have a glimpse of this style).

for more: arkenidar/graphic gh repo
https://github.com/arkenidar/graphic

| file       | purpose      |
| ---------- | ------------ |
| app.lua    | luajit app   |
| main.lua   | love2d app   |
| common.lua | common parts |

# additional setup (one time)
- **Manjaro** GNU/Linux:
    * `pamac install luajit sdl2 sdl2_image`
    * `pamac install love`
- MS **Windows**: (**MSYS** with MinGW)
    * `pacman -S mingw-w64-x86_64-luajit`
    * `pacman -S mingw-w64-x86_64-SDL2 mingw-w64-x86_64-SDL2_image`

# launching (from repo folder)
- launch app.lua with `luajit app.lua`
- launch main.lua with `love .`
