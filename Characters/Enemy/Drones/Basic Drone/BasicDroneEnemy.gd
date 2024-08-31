class_name BasicDroneEnemy extends GenericEnemy
@onready var navigation_agent:NavigationAgent2D=$NavigationAgent2D
enum states{IDLE, PATH_TO_TARGET, IN_RANGE_OF_TARGET, RETURNING_TO_LOCATION}
var state:=states.IDLE 
var shots={4:false, 6:false} 
var bullet = preload("res://Characters/Enemy/Drones/Basic Drone/bullet.tscn")

func _ready() -> void:
	super()
	sfx_frame=8
func _physics_process(delta):
	if not dying:
		if player_detected and player.global_position.x>=global_position.x:
			turn(true)
		elif player_detected:
			turn(false)
		match state:
			states.PATH_TO_TARGET:
				move_to_target(delta)
			states.IN_RANGE_OF_TARGET:
				if global_position.distance_to(player.global_position)>100 and ray_query(global_position, player.global_position)["collider"]==player:
					state=states.PATH_TO_TARGET
				sprite.set_animation("idle_fire")
				if shots.has(sprite.frame) and not shots[sprite.frame]:
					shots[sprite.frame]=true
					var b=bullet.instantiate() 
					add_child(b)
	



func _on_player_found():
	state=states.PATH_TO_TARGET


func _on_player_lost():
	state=states.RETURNING_TO_LOCATION


func _on_navigation_refresh_timeout() -> void:
	navigation_agent.target_position=player.global_position+Vector2(0, 30)

func move_to_target(delta):
	var direction = Vector2.ZERO
	
	direction = navigation_agent.get_next_path_position() - global_position
	direction = direction.normalized()
	
	velocity = velocity.lerp(direction * speed, 2 * delta)
	if facing_right:
		if velocity.x>0:
			sprite.set_animation("walk")
		else:
			sprite.set_animation("walk_back")
	else:
		if velocity.x>0:
			sprite.set_animation("walk_back")
		else:
			sprite.set_animation("walk")
	move_and_slide()


func _on_navigation_agent_2d_target_reached() -> void:
	velocity.move_toward(Vector2.ZERO, 1)
	state=states.IN_RANGE_OF_TARGET


func _on_hitbox_sprite_animation_looped() -> void:
	for key in shots.keys():
		shots[key]=false
