class_name GenericEnemy extends GravityCharacter

var player_detected:=false
@onready var player:PlayerCharacter=get_tree().get_root().get_node("PlayerCharacter")
func _ready():
	var texture=$HitboxSprite.sprite_frames.get_frame_texture($HitboxSprite.animation, $HitboxSprite.frame)
	$Area2D/CollisionShape2D.shape.radius=max(texture.get_size().x, texture.get_size().y)*10
	pass
func _on_area_2d_body_entered(body):
	if body==player and ray_query(global_position, player.global_position)["collider"]==player:
		player_detected=true


func _on_area_2d_body_exited(body):
	if body==player:
		player_detected=false

func ray_query(from:Vector2i, to:Vector2i) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to, 5)
	query.exclude = [self]
	return space_state.intersect_ray(query)
