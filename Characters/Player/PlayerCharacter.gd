extends GravityCharacter
enum states {IDLE, RUN, STILL_ATTACK, ROLL, RUN_ATTACK}
var state=states.IDLE
var jumping=false
signal state_change(state)

func _input(event):
	if(event.is_action_pressed("jump") and state!=states.ROLL):
		velocity.y += JUMP_VELOCITY
func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta
	if not is_on_floor():
		jumping=true
	elif jumping:
		jumping=false
		change_state(states.ROLL)
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
	if(state!=new_state):
		state=new_state
		state_change.emit(state)
	
