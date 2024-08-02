extends GravityCharacter
enum states {IDLE, RUN, STILL_ATTACK, ROLL, RUN_ATTACK}
var state=states.IDLE
var jumping=false
var floor=0
var max_jump=0
@onready var normal_collision_layer=collision_layer
signal state_change(state)
func _input(event):
	if event.is_action_pressed("jump") and state!=states.ROLL and is_on_floor():
		velocity.y += JUMP_VELOCITY
	if event.is_action_pressed("roll") and is_on_floor() and state!=states.ROLL:
		if facing_right:
			velocity.x=speed
		else:
			velocity.x=-speed
		change_state(states.ROLL)
func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	if not is_on_floor():
		jumping=true
		max_jump=min(max_jump, position.y-floor)
	elif jumping:
		jumping=false
		if(max_jump<-250):
			change_state(states.ROLL)
		max_jump=0
	else:
		floor=position.y
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
	elif is_on_floor() and state!=states.ROLL:
		velocity.x = move_toward(velocity.x, 0, speed)
	if not state==states.ROLL:
		if(velocity.x>0):
			facing_right=true
			change_state(states.RUN)
		elif(velocity.x<0):
			facing_right=false
			change_state(states.RUN)
		else:
			change_state(states.IDLE)
	move_and_slide()

func change_state(new_state):
	if(new_state==states.ROLL):
		collision_layer=1
	else:
		collision_layer=normal_collision_layer
	if(state!=new_state):
		state=new_state
		state_change.emit(state)
	
