extends RigidBody2D
var facing_right=true
@onready var player:PlayerCharacter=get_parent().get_node("PlayerCharacter")
@onready var neutral_position=global_position
var moving_up=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position=global_position.move_toward(neutral_position, delta)


func _on_body_entered(body):
	moving_up=false
	if body.global_position.y<global_position.y-20:
		gravity_scale=0.05
	pass # Replace with function body.


func _on_body_exited(body):
	moving_up=true
	gravity_scale=0
	pass # Replace with function body.
