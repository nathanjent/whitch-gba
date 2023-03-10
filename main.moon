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

is_state = (e, s) -> s == entslot e, Slot.STATE
set_state = (e, s) -> entslot e, Slot.STATE, s
is_jumping = (e) -> is_state e, State.JUMP
is_running = (e) -> is_state e, State.RUN
is_idle = (e) -> is_state e, State.IDLE
set_jumping = (e) -> set_state e, State.JUMP
set_running = (e) -> set_state e, State.RUN
set_idle = (e) -> set_state e, State.IDLE

main_loop = (update, draw) ->
  while true
    update delta!
    clear!
    draw!
    display!

-- map collision is planned feature
if not ecolm
  export ecolm = (entity, layer, tile_id) ->
    false

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
    if is_idle dan
      set_running dan
  if vx_prev < vx_max and btn Key.RIGHT
    vx += acc_x
    flipx = true
    if is_idle dan
      set_running dan
  if vx == vx_prev
    if vx_prev > 0.5
      vx -= acc_x / 2
    else if vx_prev < -0.5
      vx += acc_x / 2
    else
      vx = 0

  if vy == 0 and btn(Key.B) and not is_jumping(dan)
    vy = -vy_max
    set_jumping dan

  if ecolm dan, 2, 1
    vy = 0
    vx = 0
    
  if ecolt dan, Tag.GROUND
    vy = 0
    if is_jumping dan
      set_idle dan
  else
    vy += acc_y
    
  if vx == 0 and vy == 0
    set_idle dan

  if is_idle dan
      cur_frame_prev = 5

  if is_jumping dan
      cur_frame_prev = 1

  entslot dan, Slot.VEL_X, vx
  entslot dan, Slot.VEL_Y, vy
  entspd dan, vx, vy

  -- animation
  if t >= entslot(dan, Slot.NEXT_FRAME) and is_running dan
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
  print "dan x:#{dan_x} y:#{dan_y}", 0, 1
  print "state:#{entslot(dan, Slot.STATE)}", 0, 2
  vx_prev = entslot dan, Slot.VEL_X
  vy_prev = entslot dan, Slot.VEL_Y
  print "dan vx:#{vx_prev} vy:#{vy_prev}", 0, 3

main_loop update, draw

