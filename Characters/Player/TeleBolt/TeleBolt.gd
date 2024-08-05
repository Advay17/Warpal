extends CharacterBody2D

@export var speed=2000
@onready var player=get_parent().get_node("PlayerCharacter")
func _ready():
	global_position=player.global_position
	velocity=global_position.direction_to(get_global_mouse_position())*speed
	
func _physics_process(delta):
	rotation_degrees+=20
	if move_and_collide(velocity*delta):
		player.global_position=global_position
		player.porting=false
		queue_free()
		pass



func _on_visible_on_screen_notifier_2d_screen_exited():
	get_node("DeleteTimer").start(0)
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_entered():
	get_node("DeleteTimer").stop()

func _on_delete_timer_timeout():
	player.porting=false
	queue_free()

