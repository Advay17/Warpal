extends Camera2D

@onready var horizontal_dead_zone:Area2D=get_parent().get_node("HorizontalDeadZone")
@onready var vertical_dead_zone:Area2D=get_parent().get_node("VerticalDeadZone")
@onready var player:GravityCharacter=get_parent().get_node("PlayerCharacter")
# Called when the node enters the scene tree for the first time.
func _ready():
	global_position=player.position
	horizontal_dead_zone.global_position=player.global_position
	vertical_dead_zone.global_position=player.global_position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	horizontal_dead_zone.position.y=player.position.y
	vertical_dead_zone.position.x=player.position.x
	position_smoothing_speed=player.velocity.length()/75
	if not horizontal_dead_zone.overlaps_area(player.get_node("GeneralArea")):
		position.x=player.position.x
		horizontal_dead_zone.global_position.x=move_toward(horizontal_dead_zone.global_position.x, player.global_position.x, max(player.velocity.x/60, 5))
		pass
	if not vertical_dead_zone.overlaps_area(player.get_node("GeneralArea")):
		position.y=player.position.y-200
		vertical_dead_zone.global_position.y=move_toward(vertical_dead_zone.global_position.y, player.global_position.y, max(player.velocity.y/60, 5))
		pass
