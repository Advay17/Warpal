extends Camera2D

@onready var dead_zone:Area2D=get_parent().get_node("DeadZone")
@onready var player:GravityCharacter=get_parent().get_node("PlayerCharacter")
# Called when the node enters the scene tree for the first time.
func _ready():
	position=player.position
	dead_zone.position=player.position
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not dead_zone.overlaps_area(player.get_node("GeneralArea")):
		print(position.move_toward(player.position, 5))
		position=position.move_toward(player.position, 5)
		dead_zone.position=dead_zone.position.move_toward(player.position, 5)
		pass
