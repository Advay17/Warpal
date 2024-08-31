extends RigidBody2D

@onready var direction=global_position.direction_to(get_parent().player.global_position)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation=direction.angle()
	apply_force(direction*1000)


func _on_body_entered(body: Node) -> void:
	if body is PlayerCharacter:
		body.dmg(5)
	queue_free()
