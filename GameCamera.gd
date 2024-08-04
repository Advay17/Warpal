extends Camera2D

@onready var horizontal_dead_zone:Area2D=get_parent().get_node("HorizontalDeadZone")
@onready var vertical_dead_zone:Area2D=get_parent().get_node("VerticalDeadZone")
@onready var player:GravityCharacter=get_parent().get_node("PlayerCharacter")
# Called when the node enters the scene tree for the first time.
func _ready():
	position=player.position
	horizontal_dead_zone.position=player.position
	vertical_dead_zone.position=player.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	horizontal_dead_zone.position.y=player.position.y
	vertical_dead_zone.position.x=player.position.x
	if not horizontal_dead_zone.overlaps_area(player.get_node("GeneralArea")):
		position.x=move_toward(position.x, player.position.x, max(player.velocity.x/60, 5))
		horizontal_dead_zone.position.x=move_toward(horizontal_dead_zone.position.x, player.position.x, max(player.velocity.x/60, 5))
		pass
	if not vertical_dead_zone.overlaps_area(player.get_node("GeneralArea")):
		position.y=move_toward(position.y, player.position.y, max(player.velocity.y/60, 5))
		vertical_dead_zone.position.y=move_toward(vertical_dead_zone.position.y, player.position.y, max(player.velocity.y/60, 5))
		pass