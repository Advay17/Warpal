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



func _on_visible_on_screen_notifier_2d_screen_exited():
	get_node("DeleteTimer").start(0)
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_entered():
	get_node("DeleteTimer").stop()

func _on_delete_timer_timeout():
	parent.porting=false
	queue_free()

