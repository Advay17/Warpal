extends GravityCharacter
enum states{IDLE, JUMP, STILL_ATTACK, ROLL, RUN_ATTACK}

func _process(delta):
	match(states):
		states.IDLE:
			pass
		states.JUMP:
			pass
		states.STILL_ATTACK:
			pass
		states.ROLL:
			pass
		states.RUN_ATTACK:
			pass

func _input(event):
	if event.is_action_pressed("right"):
		facing_right=true
		pass
	elif event.is_action_pressed("left"):
		facing_right=false
		pass
