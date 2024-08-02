class_name HitboxSprite extends AnimatedSprite2D

@onready var parent:GravityCharacter = get_parent()
var collisions_dict={}
##Dictionary of animations, where each animation has an offset and an array of frames
func _ready() -> void:
	play("default")
	for animation in sprite_frames.get_animation_names():
		collisions_dict[animation]=[]
		collisions_dict[animation].resize(sprite_frames.get_frame_count(animation))




func _on_frame_changed():
	for polygon in get_tree().get_nodes_in_group(parent.name+"hitbox"):
		polygon.queue_free()
	if not collisions_dict[animation][frame]:
		collisions_dict[animation][frame]=[]
		var bitmap = BitMap.new()
		var texture=sprite_frames.get_frame_texture(animation, frame)
		var image=texture.get_image()
		bitmap.create_from_image_alpha(image)
		if centered:
				var s=bitmap.get_size()
				collisions_dict[animation][frame].append(Vector2(s.x, s.y)/2)
		collisions_dict[animation][frame].append(bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size())))
		for poly in collisions_dict[animation][frame][1]:
			var collision_polygon = CollisionPolygon2D.new()
			collision_polygon.polygon = poly
			parent.add_child(collision_polygon)
			if centered:
				collision_polygon.position -= collisions_dict[animation][frame][0]
			# Generated polygon will not take into account the half-width and half-height offset
			# of the image when "centered" is on. So move it backwards by this amount so it lines up.
			collision_polygon.add_to_group(parent.name+"hitbox")
	else:
		for shape in collisions_dict[animation][frame][1]:
			var collision_polygon=CollisionPolygon2D.new()
			collision_polygon.polygon = shape
			parent.add_child(collision_polygon)
			if centered:
				collision_polygon.position -= collisions_dict[animation][frame][0]
			collision_polygon.add_to_group(parent.name+"hitbox")
