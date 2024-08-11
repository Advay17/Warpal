class_name HitboxSprite extends AnimatedSprite2D

@onready var parent:CollisionObject2D = get_parent()
@onready var hitbox:CollisionShape2D = parent.get_node("Hitbox")
var collisions_dict={}
##Dictionary of animations, where each animation has an offset and an array of frames
func _ready() -> void:
	play("default")
	for animation in sprite_frames.get_animation_names():
		collisions_dict[animation]=[]
		collisions_dict[animation].resize(sprite_frames.get_frame_count(animation))

func _process(delta):
	if parent.facing_right:
		if flip_h:
			flip_h=false
			for node in parent.get_children():
				if node!=self:
					node.position.x*=-1
	else:
		if not flip_h:
			flip_h=true
			for node in parent.get_children():
				if node!=self:
					node.position.x*=-1


func _physics_process(delta):
	#for polygon in get_tree().get_nodes_in_group(parent.name+"hitbox"):
		#polygon.queue_free()
	if not collisions_dict[animation][frame]:
		var bitmap = BitMap.new()
		var texture=sprite_frames.get_frame_texture(animation, frame)
		var image=texture.get_image()
		bitmap.create_from_image_alpha(image)
		collisions_dict[animation][frame]=texture.get_size()
		var max_x=-9223372036854775807 
		var min_x=9223372036854775807 
		var max_y=-9223372036854775807 
		var min_y=9223372036854775807
		#if centered:
				#var s=bitmap.get_size()
				#collisions_dict[animation][frame].append(Vector2(s.x, s.y)/2)
		var polygons=bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, texture.get_size())) 
		for polygon in polygons:
			for point in polygon:
				max_x=max(max_x, point.x)
				max_y=max(max_y, point.y)
				min_x=min(min_x, point.x)
				min_y=min(min_y, point.y)
		collisions_dict[animation][frame]=Vector2(max_x-min_x, max_y-min_y)
		#for poly in collisions_dict[animation][frame][1]:
			#collision_polygon.polygon = poly
			#collision_polygon.position=Vector2(0,0)
			#collision_polygon.position+=offset
			#if centered:
				#collision_polygon.position -= collisions_dict[animation][frame][0]
			# Generated polygon will not take into account the half-width and half-height offset
			# of the image when "centered" is on. So move it backwards by this amount so it lines up.
			#collision_polygon.add_to_group(parent.name+"hitbox")
	hitbox.shape.radius=collisions_dict[animation][frame].x
	hitbox.shape.height=collisions_dict[animation][frame].y
	#else:
		#pass
		#for shape in collisions_dict[animation][frame][1]:
			#collision_polygon.position=Vector2(0,0)
			#collision_polygon.polygon = shape
			#collision_polygon.position+=offset
			#if centered:
				#collision_polygon.position -= collisions_dict[animation][frame][0]
