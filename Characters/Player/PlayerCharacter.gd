class_name PlayerCharacter extends GravityCharacter
enum states {IDLE, RUN, STILL_ATTACK, ROLL, RUN_ATTACK, BOLT}
var motionless_states=[states.STILL_ATTACK, states.RUN_ATTACK, states.ROLL, states.BOLT]
var state=states.IDLE
var jumping=false 
var climbing=false
var porting=false
var floor_position=0
var max_height=9223372036854775807
var sword_damage=20 
@export var health=100
@onready var health_bar=get_parent().get_node("CanvasLayer/UI/HealthBar")
#@onready var health_bar=$UI/HealthBar
@onready var normal_collision_mask=collision_mask
signal state_change(state)
signal attack
signal died
@onready var shape_cast_2d = $FloorDetector
func _input(event):
	if event.is_action_pressed("jump") and state!=states.ROLL:
		if(is_on_floor()):
			velocity.y += JUMP_VELOCITY
		elif is_on_wall() and not get_slide_collision(get_slide_collision_count()-1).get_collider_shape() is GenericEnemy and Input.get_axis("left", "right")!=0 and (facing_right and round(get_wall_normal().x)==-1) or (not facing_right and round(get_wall_normal().x)==1):
			climbing=true
	if climbing and (event.is_action_released("jump") or (facing_right and not Input.is_action_pressed("right")) or (not facing_right and not Input.is_action_pressed("left"))):
		climbing=false
	elif event.is_action_pressed("roll") and is_on_floor() and state!=states.ROLL:
		if facing_right:
			velocity.x=speed
		else:
			velocity.x=-speed
		change_state(states.ROLL)
	elif event.is_action_pressed("attack") and (not is_on_wall_only() or get_last_slide_collision().get_collider() is GenericEnemy):
		if state==states.IDLE:
			change_state(states.STILL_ATTACK)
			await state_change
		elif state==states.RUN:
			change_state(states.RUN_ATTACK)
			await state_change
	elif event.is_action_pressed("bolt") and not state in motionless_states and not porting and ((facing_right and get_global_mouse_position().x>global_position.x) or (!facing_right and get_local_mouse_position().x<global_position.x)):
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
			turn(true)
			change_state(states.RUN)
		elif(velocity.x<0):
			turn(false)
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
		if is_on_wall() and not is_on_floor() and state!=states.ROLL:
			velocity.y*=0.5
	if(climbing):
		velocity.y+=JUMP_VELOCITY*0.25
	move_and_slide()

func change_state(new_state):
	if(new_state==states.ROLL):
		collision_mask=1
	else:
		collision_mask=normal_collision_mask
	if(state!=new_state):
		state=new_state
		state_change.emit(state)

func dmg(damage:int):
	health-=damage
	health_bar.value=health
	if health<=0:
		get_tree().reload_current_scene()
