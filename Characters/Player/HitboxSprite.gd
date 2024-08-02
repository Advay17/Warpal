class_name HitboxSprite extends AnimatedSprite2D

@onready var parent:GravityCharacter = get_parent()
var collisions_dict={}
##Dictionary of animations, where each animation has an offset and an array of frames
func _ready() -> void:
	play("default")
	for animation in sprite_frames.get_animation_names():
		collisions_dict[animation]=[]




func _on_frame_changed():
	if len(collisions_dict[animation])<frame:
		collisions_dict[animation].append([])
		for polygon in get_tree().get_nodes_in_group("hitbox"):
			polygon.queue_free()
		var bitmap = BitMap.new()
		var texture=sprite_frames.get_frame_texture(animation, frame)
		var image=texture.get_image()
		bitmap.create_from_image_alpha(image)
		if centered:
				var s=bitmap.get_size()
				collisions_dict[animation][frame].append(Vector2(s.x, s.y)/2)
		collisions_dict[animation][frame].append(bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size())))
		for poly in collisions_dict[animation][frame][0]:
			var collision_polygon = CollisionPolygon2D.new()
			collision_polygon.polygon = poly
			parent.add_child(collision_polygon)
			if centered:
				collision_polygon.position -= collisions_dict[animation][frame][1]
			# Generated polygon will not take into account the half-width and half-height offset
			# of the image when "centered" is on. So move it backwards by this amount so it lines up.
			collision_polygon.add_to_group("hitbox")
	else:
		for shape in collisions_dict[animation][frame][0]:
			var collision_polygon=CollisionPolygon2D.new()
			collision_polygon.polygon = shape
			parent.add_child(collision_polygon)
			if centered:
				collision_polygon.position -= collisions_dict[animation][frame][1]
			collision_polygon.add_to_group("hitbox")
