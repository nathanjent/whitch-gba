
local app = {
   name = "NewProject",

   tilesets = {
      "overlay/overlay.bmp",
      "tiles/tilesheet.bmp",
   },

   spritesheets = {
      "sprites/spritesheet.bmp",
   },

   audio = {
      -- "music/song.raw"
   },

   scripts = {
      -- the ROM expects main.lua as the entrypoint
      "main.lua",
   },

   misc = {
      "tilemaps/map_overlay.csv",
      "tilemaps/map_tile_1.csv",
      "tilemaps/map_tile_0.csv",
      "tilemaps/map_background.csv",
   }
}

return app
