lerp=(a,b,t)->(1-t)*a+t*b
inv_lerp=(a,b,v)->(v-a)/(b-a)
remap=(i_min,i_max,o_min,o_max,v)->
	lerp o_min,o_max,inv_lerp(i_min,i_max,v)

txtr 0, "overlay/overlay.bmp"
txtr 2, "tiles/tilesheet.bmp"
txtr 4, "sprites/spritesheet.bmp"

cam = ent!
runman = ent!
entpos runman, 30, 30
entspr runman, 1
flip_x = false
tilemap "tilemaps/map_background.csv", 2, 64, 64

main_loop = (update, draw) ->
  while true
    update delta!
    clear!
    draw!
    display!

update = (dt) ->
  dvx,dvy = 0,0
  state = 'idle'

  if btn 4
    dvx -= 1
    flip_x = false
    state = 'run'
    entanim runman, 1, 3, 12
  if btn 5
    dvx += 1
    flip_x = true
    state = 'run'
    entanim runman, 1, 3, 12
  if btn 6
    dvy -= 1
  if btn 7
    dvy += 1

  entspd runman, dvx, dvy
  x,y = entpos runman
  cam_x, cam_y = entpos cam
  entpos cam,
    math.min(64, lerp(cam_x, 64-x, 0.05)),
    math.min(64, lerp(cam_y, 64-y, 0.05))

  --if state == 'idle'
  --  entspr runman, 0, flip_x

draw = ->
  print "Hello", 64, 64
  cam_x, cam_y = entpos cam
  camera cam_x, cam_y

main_loop update, draw
