extends CharacterBody2D

@export var speed=500
func _ready():
	velocity=global_position.direction_to(get_global_mouse_position())*speed
	
func _physics_process(delta):
	for hitbox in get_tree().get_nodes_in_group(name+"hitbox"):
		pass
	move_and_slide()

