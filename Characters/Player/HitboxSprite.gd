class_name HitboxSprite extends AnimatedSprite2D

@onready var parent = get_parent()

func _ready() -> void:
	play("default")




func _on_frame_changed():
	for polygon in get_tree().get_nodes_in_group("hitbox"):
		polygon.queue_free()
	var bitmap = BitMap.new()
	var texture=sprite_frames.get_frame_texture(animation, frame)
	bitmap.create_from_image_alpha(texture.get_image())

	var polys = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size()))
	for poly in polys:
		var collision_polygon = CollisionPolygon2D.new()
		collision_polygon.polygon = poly
		parent.add_child(collision_polygon)

		# Generated polygon will not take into account the half-width and half-height offset
		# of the image when "centered" is on. So move it backwards by this amount so it lines up.
		if centered:
			var s=bitmap.get_size()
			collision_polygon.position -= Vector2(s.x, s.y)/2
		collision_polygon.add_to_group("hitbox")
