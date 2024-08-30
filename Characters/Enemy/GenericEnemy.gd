class_name GenericEnemy extends GravityCharacter

var player_detected:=false 
signal player_found
signal player_lost
@onready var player:PlayerCharacter=get_parent().get_node("PlayerCharacter")
@export var health=100
@onready var sound:AudioStreamPlayer2D = $AudioStreamPlayer2D
func _ready():
	var texture=$HitboxSprite.sprite_frames.get_frame_texture($HitboxSprite.animation, $HitboxSprite.frame)
	$Area2D/CollisionShape2D.shape.radius=max(texture.get_size().x, texture.get_size().y)*10
	pass
func _on_area_2d_body_entered(body):
	var c=ray_query(global_position, player.global_position) 
	print(c)
	if body==player and c.has("collider") and c.get("collider")==player:
		player_detected=true
		player_found.emit()


func _on_area_2d_body_exited(body):
	if body==player:
		player_detected=false
		player_lost.emit()

func ray_query(from:Vector2i, to:Vector2i) -> Dictionary:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(from, to, 3)
	query.exclude = [self]
	return space_state.intersect_ray(query)

func dmg(damage):
	health-=damage
	sound.play()
	print(health)
	if(health<=0):
		$HitboxSprite.play("death")
		await $HitboxSprite.animation_looped
		queue_free()
