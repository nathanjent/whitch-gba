
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
      -- "data/example.txt
   }
}

return app
