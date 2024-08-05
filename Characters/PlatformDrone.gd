extends StaticBody2D
var facing_right=true
@onready var player:PlayerCharacter=get_parent().get_node("PlayerCharacter")
@onready var neutral_position=global_position
var moving_up=false 
var delta_t 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(global_position)
	if not delta_t:
		delta_t=delta
	if moving_up:
		global_position=global_position.move_toward(neutral_position, 4)
		if neutral_position==global_position:
			moving_up=false


func _on_area_2d_area_entered(area):
	moving_up=false
	if area.get_parent()==player:
		var velocity=Vector2(0, gravity)*delta_t 
		print(move_and_collide(Vector2(0, 999999*delta_t)))
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	if area.get_parent()==player:
		moving_up=true
