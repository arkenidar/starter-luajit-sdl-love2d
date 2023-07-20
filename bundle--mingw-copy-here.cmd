echo ********************************
echo mingw copy essentials
echo ********************************
echo.

echo ********************************
echo custom luajit binaries for console-less variant
echo ********************************
echo .

echo https://luajit.org/download.html
echo git clone https://luajit.org/git/luajit.git

echo https://gist.github.com/arkenidar/ebde4174dad3cf662f04a9e21ce4543b
echo  How to build windowless* #Lua for #Windows (* meaning: no visible console for standard console output, no "console window", like pythonw.exe ) 

echo edit file : src/luajit.c
echo // https://gist.github.com/arkenidar/ebde4174dad3cf662f04a9e21ce4543b
echo append these 3 lines (content without "rem") to the end of src/luajit.c source file:

echo #include <windows.h>
echo int WINAPI WinMain (HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nShowCmd)
echo { return main(__argc, __argv); }

echo make MYLDFLAGS=-mwindows
copy c:\opt\Dropbox\gh-repos\luajit\src\luajit.exe .
copy c:\opt\Dropbox\gh-repos\luajit\src\lua51.dll .

echo ********************************
echo copy DLL files and their (cascading) dependencies
echo ********************************
echo .

echo ********************************
copy c:\msys64\mingw64\bin\SDL2.DLL .
copy c:\msys64\mingw64\bin\SDL2_image.DLL .
echo ********************************
echo.

echo ********************************
echo required by SDL2_image.DLL
echo ********************************
echo.

copy c:\msys64\mingw64\bin\LIBPNG16-16.DLL .
copy c:\msys64\mingw64\bin\LIBJPEG-8.DLL .
copy c:\msys64\mingw64\bin\LIBJXL.DLL .
copy c:\msys64\mingw64\bin\LIBTIFF-6.DLL .
copy c:\msys64\mingw64\bin\LIBWEBP-7.DLL .


copy c:\msys64\mingw64\bin\LIBGCC_S_SEH-1.DLL .
copy "c:\msys64\mingw64\bin\libstdc++-6.dll" .
copy c:\msys64\mingw64\bin\LIBBROTLIDEC.DLL .
copy c:\msys64\mingw64\bin\LIBHWY.DLL .
copy c:\msys64\mingw64\bin\LIBLCMS2-2.DLL .

copy c:\msys64\mingw64\bin\ZLIB1.DLL .
copy c:\msys64\mingw64\bin\LIBDEFLATE.DLL .
copy c:\msys64\mingw64\bin\LIBJBIG-0.DLL .
copy c:\msys64\mingw64\bin\LIBLERC.DLL .
copy c:\msys64\mingw64\bin\LIBLZMA-5.DLL .
copy c:\msys64\mingw64\bin\LIBZSTD.DLL .
copy c:\msys64\mingw64\bin\LIBSHARPYUV-0.DLL .
copy c:\msys64\mingw64\bin\LIBWINPTHREAD-1.DLL .
copy c:\msys64\mingw64\bin\LIBBROTLICOMMON.DLL .
