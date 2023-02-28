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
    NEXT_FRAME:2
    VEL_X:3
    VEL_Y:4
    VEL_X_MAX:5
    VEL_Y_MAX:6
    ACC_X:7
    ACC_Y:8

State=
    IDLE:1
    RUN:2

Tag=
  GROUND:1

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
entslot dan, Slot.VEL_X, 0
entslot dan, Slot.VEL_Y, 0
entslot dan, Slot.VEL_X_MAX, 5
entslot dan, Slot.VEL_Y_MAX, 3
entslot dan, Slot.ACC_X, 1
entslot dan, Slot.ACC_Y, 1
entspr dan, 1
enthb dan

ground = ent!
enthb ground, 0, 0, 240, 16
entpos ground, SCRN_W/2, 100
entspr ground, 1
entag ground, Tag.GROUND

main_loop = (update, draw) ->
  while true
    update delta!
    clear!
    draw!
    display!

update = (dt) ->
  t += 1

  vx_max = entslot dan, Slot.VEL_X_MAX
  acc_x = entslot dan, Slot.ACC_X
  acc_y = entslot dan, Slot.ACC_Y
  vx_prev = entslot dan, Slot.VEL_X
  vy_prev = entslot dan, Slot.VEL_Y
  vx,vy = vx_prev,vy_prev
  x_prev, y_prev = entpos dan
  cur_frame_prev, flipx_prev, flipy_prev = entspr dan
  cam_x, cam_y = entpos cam

  if vx_prev > -vx_max and btn Key.LEFT
    vx -= acc_x
    dan_flipx = false
    entslot dan, Slot.STATE, State.RUN
  if vx_prev < vx_max and btn Key.RIGHT
    vx += acc_x
    dan_flipx = true
    entslot dan, Slot.STATE, State.RUN
  if vx == vx_prev
    if vx_prev > vx_max
      vx -= acc_x
    else if vx_prev < vx_max
      vx += acc_x
    else
      vx = 0

  if ecolt dan,Tag.GROUND
    vy = 0
  else
    vy += acc_y

  if vx == 0 and vy == 0
    entslot dan, Slot.STATE, State.IDLE

  entslot dan, Slot.VEL_X, vx
  entslot dan, Slot.VEL_Y, vy
  entspd dan, vx, vy
  entspr dan, dan_cur_frame, dan_flipx

  if t >= entslot(dan, Slot.NEXT_FRAME) and "run" == entslot(dan, Slot.STATE)
    dan_cur_frame += 1
    entslot dan, Slot.NEXT_FRAME, t + 12
    if dan_cur_frame > 3
      dan_cur_frame = 1

  entpos cam, cam_x, cam_y
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

