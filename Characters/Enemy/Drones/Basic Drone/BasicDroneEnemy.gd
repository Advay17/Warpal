class_name BasicDroneEnemy extends GenericEnemy
@onready var navigation_agent:NavigationAgent2D=$NavigationAgent2D
enum states{IDLE, PATH_TO_TARGET, IN_RANGE_OF_TARGET, RETURNING_TO_LOCATION}
var state:=states.IDLE 

func _ready() -> void:
	super()
	sfx_frame=8
func _physics_process(delta):
	if not dying:
		match state:
			states.PATH_TO_TARGET:
				move_to_target(delta)
			states.IN_RANGE_OF_TARGET:
				if player.global_position.x>=global_position.x:
					turn(true)
				else:
					turn(false)
				if global_position.distance_to(player.global_position)>100 and ray_query(global_position, player.global_position)["collider"]==player:
					state=states.PATH_TO_TARGET
	



func _on_player_found():
	state=states.PATH_TO_TARGET


func _on_player_lost():
	state=states.RETURNING_TO_LOCATION


func _on_navigation_refresh_timeout() -> void:
	navigation_agent.target_position=player.global_position

func move_to_target(delta):
	var direction = Vector2.ZERO
	
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, 2 * delta)
	if(velocity.x>0):
		turn(true)
	elif(velocity.x<0):
		turn(false)
	move_and_slide()


func _on_navigation_agent_2d_target_reached() -> void:
	velocity.move_toward(Vector2.ZERO, 1)
	state=states.IN_RANGE_OF_TARGET
