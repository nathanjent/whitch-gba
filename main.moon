lerp=(a,b,t)->(1-t)*a+t*b
inv_lerp=(a,b,v)->(v-a)/(b-a)
remap=(i_min,i_max,o_min,o_max,v)->
	lerp o_min,o_max,inv_lerp(i_min,i_max,v)

txtr 0, "overlay/overlay.bmp"
txtr 2, "tiles/tilesheet.bmp"
txtr 4, "sprites/spritesheet.bmp"

SCR_W=240
SCR_H=160

cam = ent!
dan = ent!
entspr dan, 1
tilemap "tilemaps/map_background.csv", 2, 64, 64

main_loop = (update, draw) ->
  while true
    update delta!
    clear!
    draw!
    display!

update = (dt) ->
  dx,dy = 0,0

  dan_x, dan_y = entpos dan
  dan_spr, dan_flipx, dan_flipy = entspr dan
  cam_x, cam_y = entpos cam

  if btn 4
    dx -= 1
    dan_flipx = false
  if btn 5
    dx += 1
    dan_flipx = true
  if btn 6
    dy -= 1
  if btn 7
    dy += 1

  entpos cam, cam_x + dx, cam_y + dy
    -- math.min(64, lerp(cam_x, x-10, 0.05)),
    -- math.min(64, lerp(cam_y, y-30, 0.05))

  entpos dan, dan_x + dx, dan_y + dy
  entspr dan, 1, dan_flipx, dan_flipy

draw = ->
  cam_x, cam_y = entpos cam
  camera cam_x, cam_y
  print "cam x:#{cam_x} y:#{cam_y}", 0, 0

  dan_x, dan_y = entpos dan
  print "dan x:#{dan_x} y:#{dan_y}", 0, 1

main_loop update, draw
