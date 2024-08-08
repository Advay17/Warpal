class_name PlayerCharacter extends GravityCharacter
enum states {IDLE, RUN, STILL_ATTACK, ROLL, RUN_ATTACK, BOLT}
var motionless_states=[states.STILL_ATTACK, states.RUN_ATTACK, states.ROLL, states.BOLT]
var state=states.IDLE
var jumping=false
var porting=false
var floor_position=0
var max_height=9223372036854775807
var sword_damage=20
@onready var normal_collision_mask=collision_mask
signal state_change(state)
signal attack
@onready var shape_cast_2d = $FloorDetector
func _input(event):
	if event.is_action_pressed("jump") and state!=states.ROLL and is_on_floor():
		velocity.y += JUMP_VELOCITY
	elif event.is_action_pressed("roll") and is_on_floor() and state!=states.ROLL:
		if facing_right:
			velocity.x=speed
		else:
			velocity.x=-speed
		change_state(states.ROLL)
	elif event.is_action_pressed("attack"):
		if state==states.IDLE:
			change_state(states.STILL_ATTACK)
			await state_change
		elif state==states.RUN:
			change_state(states.RUN_ATTACK)
			await state_change
	elif event.is_action_pressed("bolt") and not state in motionless_states and not porting and rad_to_deg(position.angle_to(get_local_mouse_position()))<0:
		porting=true
		change_state(states.BOLT)
		pass
func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	if not is_on_floor():
		jumping=true
		max_height=min(max_height, position.y)
	elif jumping:
		jumping=false
		if(max_height-position.y<-250) and not (shape_cast_2d.is_colliding() and shape_cast_2d.get_collider() in get_tree().get_nodes_in_group("no_roll_floor")):
			change_state(states.ROLL)
		max_height=9223372036854775807
	else:
		floor_position=position.y
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if state==states.ROLL and not shape_cast_2d.is_colliding():
		velocity.x=0
	if direction and not state==states.ROLL:
		velocity.x = direction * speed
	elif is_on_floor() and state!=states.ROLL:
		velocity.x = move_toward(velocity.x, 0, speed)
	if not state in motionless_states:
		if(velocity.x>0):
			facing_right=true
			change_state(states.RUN)
		elif(velocity.x<0):
			facing_right=false
			change_state(states.RUN)
		else:
			change_state(states.IDLE)
	if is_on_floor():
		rotation=get_floor_angle()
		if get_floor_normal().x<0:
			rotation*=-1
		velocity.rotated(rotation)
	else:
		rotation=0
		if is_on_wall() and state!=states.ROLL:
			velocity.y*=0.5
	move_and_slide()

func change_state(new_state):
	if(new_state==states.ROLL):
		collision_mask=1
	else:
		collision_mask=normal_collision_mask
	if(state!=new_state):
		state=new_state
		state_change.emit(state)
	
