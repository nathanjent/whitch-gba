txtr 0, "overlay/overlay.bmp"
txtr 2, "tiles/tilesheet.bmp"
txtr 4, "sprites/spritesheet.bmp"

tilemap "tilemaps/map_background.csv", 3, 32, 32

runman = ent!
entspr runman, 1
entpos runman, 60,60
flip_x = false

while true
  -- update logic here:
  dvx,dvy = 0,0
  state = 'idle'

  if btn 4
    dvx -= 1
    flip_x = false
    state = 'run'
    entanim runman,0,3,12
  if btn 5
    dvx += 1
    flip_x = true
    state = 'run'
    entanim runman,0,3,12
  if btn 6
    dvy -= 1
  if btn 7
    dvy += 1

  entspd runman, dvx, dvy

  --if state == 'idle'
  --  entspr runman,0,flip_x

  clear!

  -- graphics updates here:


  display!
