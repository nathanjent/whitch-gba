SCRN_W=240
SCRN_H=160
Key=
	A:0
	B:1
	L:8
	R:9
	START:2
	SELECT:3
	LEFT:4
	RIGHT:5
	UP:6
	DOWN:7

Slot=
	STATE:1
	NEXT_FRAME:3

State=
	IDLE:1
	RUN:2

lerp = (a,b,t)->(1-t)*a+t*b
inv_lerp = (a,b,v)->(v-a)/(b-a)
remap = (i_min,i_max,o_min,o_max,v)->
  lerp o_min,o_max,inv_lerp(i_min,i_max,v)

txtr 0, "overlay/overlay.bmp"
txtr 2, "tiles/tilesheet.bmp"
txtr 4, "sprites/spritesheet.bmp"

tilemap "tilemaps/map_background.csv", 2, 64, 64

t=0
cam = ent!
dan = ent!
entslots dan, 16
entslot dan, Slot.NEXT_FRAME, 0
entslot dan, Slot.STATE, State.IDLE
entspr dan, 1

main_loop = (update, draw) ->
  while true
    update delta!
    clear!
    draw!
    display!

update = (dt) ->
  t += 1
  dx,dy = 0,0

  dan_x, dan_y = entpos dan
  dan_cur_frame, dan_flipx, dan_flipy = entspr dan
  cam_x, cam_y = entpos cam

  if btn Key.LEFT
    dx -= 1
    dan_flipx = false
	entslot dan, Slot.STATE, State.RUN
  if btn Key.RIGHT
    dx += 1
    dan_flipx = true
	entslot dan, Slot.STATE, State.RUN
  if btn Key.UP
    dy -= 1
  if btn Key.DOWN
    dy += 1

  if dx == 0
	entslot dan, Slot.STATE, State.IDLE

  if t >= entslot(dan, Slot.NEXT_FRAME) and "run" == entslot(dan, Slot.STATE)
    dan_cur_frame += 1
    entslot dan, Slot.NEXT_FRAME, t + 12
    if dan_cur_frame > 3
      dan_cur_frame = 1

  entpos dan, dan_x + dx, dan_y + dy
  entspr dan, dan_cur_frame, dan_flipx

  entpos cam, cam_x + dx, cam_y + dy
    -- math.min(64, lerp(cam_x, x-10, 0.05)),
    -- math.min(64, lerp(cam_y, y-30, 0.05))

draw = ->
  print "t:#{t}"
  cam_x, cam_y = entpos cam
  camera cam_x, cam_y
  print "cam x:#{cam_x} y:#{cam_y}", 0, 1

  dan_x, dan_y = entpos dan
  print "dan x:#{dan_x} y:#{dan_y} state:#{entslot(dan, Slot.STATE)}", 0, 2

main_loop update, draw

