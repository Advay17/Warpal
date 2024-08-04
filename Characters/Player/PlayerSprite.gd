extends HitboxSprite

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if parent.facing_right:
		parent.rotation=0
		parent.scale.y=1
	else:
		parent.rotation_degrees=180
		parent.scale.y=-1

