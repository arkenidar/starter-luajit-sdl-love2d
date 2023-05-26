////////////////////////////////////////////////////////////////////////
// begin of SDL_Window

// https://github.com/libsdl-org/SDL/blob/main/src/video/SDL_sysvideo.h


//+++++++++++++++++++++++++++++++++++++++
// https://github.com/libsdl-org/SDL/blob/main/include/SDL3/SDL_video.h#L44

typedef Uint32 SDL_DisplayID;
typedef Uint32 SDL_WindowID;

//+++++++++++++++++++++++++++++++++
// https://stackoverflow.com/questions/32246738/where-can-i-find-the-definition-of-sdl-window
// https://github.com/libsdl-org/SDL/blob/main/src/video/SDL_sysvideo.h

/*+ Define the SDL window structure, corresponding to toplevel windows */
// struct SDL_Window
/* The SDL video driver */

typedef struct SDL_WindowShaper SDL_WindowShaper;
typedef struct SDL_ShapeDriver SDL_ShapeDriver;
typedef struct SDL_VideoDisplay SDL_VideoDisplay;
typedef struct SDL_VideoDevice SDL_VideoDevice;
typedef struct SDL_VideoData SDL_VideoData;
typedef struct SDL_DisplayData SDL_DisplayData;
typedef struct SDL_DisplayModeData SDL_DisplayModeData;
typedef struct SDL_WindowData SDL_WindowData;

/* Define the SDL window-shaper structure */
struct SDL_WindowShaper
{
    /* The window associated with the shaper */
    SDL_Window *window;

    /* The parameters for shape calculation. */
    SDL_WindowShapeMode mode;

    /* Has this window been assigned a shape? */
    SDL_bool hasshape;

    void *driverdata;
};

/* Define the SDL shape driver structure */
struct SDL_ShapeDriver
{
    SDL_WindowShaper *(*CreateShaper)(SDL_Window *window);
    int (*SetWindowShape)(SDL_WindowShaper *shaper, SDL_Surface *shape, SDL_WindowShapeMode *shape_mode);
};

typedef struct SDL_WindowUserData
{
    char *name;
    void *data;
    struct SDL_WindowUserData *next;
} SDL_WindowUserData;

/* Define the SDL window structure, corresponding to toplevel windows */
struct SDL_Window
{
    const void *magic;
    SDL_WindowID id;
    char *title;
    SDL_Surface *icon;
    int x, y;
    int w, h;
    int min_w, min_h;
    int max_w, max_h;
    int last_pixel_w, last_pixel_h;
    Uint32 flags;
    Uint32 pending_flags;
    float display_scale;
    SDL_bool fullscreen_exclusive;  /* The window is currently fullscreen exclusive */
    SDL_DisplayID last_fullscreen_exclusive_display;  /* The last fullscreen_exclusive display */
    SDL_DisplayID last_displayID;

    /* Stored position and size for windowed mode */
    SDL_Rect windowed;

    /* Whether or not the intial position was defined */
    SDL_bool undefined_x;
    SDL_bool undefined_y;

    SDL_DisplayMode requested_fullscreen_mode;
    SDL_DisplayMode current_fullscreen_mode;

    float opacity;

    SDL_Surface *surface;
    SDL_bool surface_valid;

    SDL_bool is_hiding;
    SDL_bool restore_on_show; /* Child was hidden recursively by the parent, restore when shown. */
    SDL_bool is_destroying;
    SDL_bool is_dropping; /* drag/drop in progress, expecting SDL_SendDropComplete(). */

    SDL_Rect mouse_rect;

    SDL_WindowShaper *shaper;

    SDL_HitTest hit_test;
    void *hit_test_data;

    SDL_WindowUserData *data;

    SDL_WindowData *driverdata;

    SDL_Window *prev;
    SDL_Window *next;

    SDL_Window *parent;
    SDL_Window *first_child;
    SDL_Window *prev_sibling;
    SDL_Window *next_sibling;
};

// end of SDL_Window
////////////////////////////////////////////////////////////////////////

// =====================================================================

////////////////////////////////////////////////////////////////////////
// begin of SDL_Renderer

#include "ffi_defs_additional/SDL_sysrender.h"

// end of SDL_Renderer
////////////////////////////////////////////////////////////////////////
