class_name PlatformDrone extends RigidBody2D
var facing_right=true
@onready var player:PlayerCharacter=get_parent().get_node("PlayerCharacter")
@onready var neutral_position=global_position
var moving_up=false 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state=states.STILL
enum states{MOVING_UP, STILL, MOVING_DOWN}
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play()
	add_to_group("no_roll_floor")
	pass # Replace with function body.

func _physics_process(delta):
	global_position.x=neutral_position.x
	scale=Vector2(2, 1.5)
	if moving_up:
		global_position.y=move_toward(global_position.y, neutral_position.y, delta*40)



func _on_area_2d_body_entered(body):
	if body==player:
		moving_up=false
		set_deferred("freeze", false)


func _on_area_2d_body_exited(body):
	if body==player:
		set_deferred("freeze", true)
		moving_up=true
