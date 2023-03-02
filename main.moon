SCRN_W=240
SCRN_H=160

Key=
    A:0
    B:1
    START:2
    SELECT:3
    LEFT:4
    RIGHT:5
    UP:6
    DOWN:7
    L:8
    R:9

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
    JUMP:3

-- entity tags
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
entslot dan, Slot.VEL_X_MAX, 2
entslot dan, Slot.VEL_Y_MAX, 5
entslot dan, Slot.ACC_X, 0.5
entslot dan, Slot.ACC_Y, 0.8
entspr dan, 1

ground = ent!
enthb ground, 0, 0, 240, 16
entpos ground, -SCRN_W / 2, 50
entag ground, Tag.GROUND

main_loop = (update, draw) ->
  while true
    update delta!
    clear!
    draw!
    display!

update = (dt) ->
  t += 1

  -- physics
  vx_max = entslot dan, Slot.VEL_X_MAX
  vy_max = entslot dan, Slot.VEL_Y_MAX
  acc_x = entslot dan, Slot.ACC_X
  acc_y = entslot dan, Slot.ACC_Y
  vx_prev = entslot dan, Slot.VEL_X
  vy_prev = entslot dan, Slot.VEL_Y
  vx, vy = vx_prev, vy_prev
  x_prev, y_prev = entpos dan
  cur_frame_prev, flipx, flipy = entspr dan
  cam_x, cam_y = entpos cam

  if vx_prev > -vx_max and btn Key.LEFT
    vx -= acc_x
    flipx = false
    if State.IDLE == entslot dan, Slot.STATE
      entslot dan, Slot.STATE, State.RUN
  if vx_prev < vx_max and btn Key.RIGHT
    vx += acc_x
    flipx = true
    if State.IDLE == entslot dan, Slot.STATE
      entslot dan, Slot.STATE, State.RUN
  if vx == vx_prev
    if vx_prev > 0.5
      vx -= acc_x / 2
    else if vx_prev < -0.5
      vx += acc_x / 2
    else
      vx = 0

  if ecolt dan, Tag.GROUND
    vy = 0
    if State.JUMP == entslot dan, Slot.STATE
      entslot dan, Slot.STATE, State.IDLE
  else
    vy += acc_y
    
  if vy == 0 and btn(Key.B) and State.JUMP != entslot dan, Slot.STATE
    vy = -vy_max
    entslot dan, Slot.STATE, State.JUMP

  if vx == 0 and vy == 0
    entslot dan, Slot.STATE, State.IDLE

  if State.IDLE == entslot dan, Slot.STATE
      cur_frame_prev = 5

  if State.JUMP == entslot dan, Slot.STATE
      cur_frame_prev = 1

  entslot dan, Slot.VEL_X, vx
  entslot dan, Slot.VEL_Y, vy
  entspd dan, vx, vy

  -- animation
  if t >= entslot(dan, Slot.NEXT_FRAME) and entslot(dan, Slot.STATE) == State.RUN
    cur_frame_prev += 1
    entslot dan, Slot.NEXT_FRAME, t + 6
    if cur_frame_prev > 3
      cur_frame_prev = 1

  entspr dan, cur_frame_prev, flipx, flipy

  entpos cam, cam_x, cam_y
    -- math.min(64, lerp(cam_x, x-10, 0.05)),
    -- math.min(64, lerp(cam_y, y-30, 0.05))

draw = ->
  cam_x, cam_y = entpos cam
  camera cam_x, cam_y
  print "cam x:#{cam_x} y:#{cam_y}"

  dan_x, dan_y = entpos dan
  print "dan x:#{dan_x} y:#{dan_y} state:#{entslot(dan, Slot.STATE)}", 0, 1
  vx_prev = entslot dan, Slot.VEL_X
  vy_prev = entslot dan, Slot.VEL_Y
  print "dan vx:#{vx_prev} vy:#{vy_prev}", 0, 2

main_loop update, draw

