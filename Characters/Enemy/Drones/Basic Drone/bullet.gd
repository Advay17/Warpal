extends RigidBody2D

@onready var direction=global_position.direction_to(get_global_mouse_position())
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation=direction


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
