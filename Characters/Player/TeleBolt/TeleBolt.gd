extends CharacterBody2D

@export var speed=2000
@onready var parent=get_parent()
func _ready():
	velocity=global_position.direction_to(get_global_mouse_position())*speed
	
func _physics_process(delta):
	rotation_degrees+=20
	if move_and_collide(velocity*delta):
		parent.global_position=global_position
		parent.porting=false
		queue_free()
		pass

