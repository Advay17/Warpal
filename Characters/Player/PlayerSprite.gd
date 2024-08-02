extends HitboxSprite

@onready var p:GravityCharacter=get_parent()
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if p.facing_right:
		p.rotation=0
		p.scale.y=1
	else:
		p.rotation_degrees=180
		p.scale.y=-1






func _on_player_character_change_state(state):
	match(state):
		p.states.IDLE:
			play("default")
		p.states.RUN:
			play("run")
		p.states.ROLL:
			play("roll")
			await animation_looped
			p.change_state(p.states.RUN)
		p.states.STILL_ATTACK:
			play("standing_attack")
			print(animation)
			while(frame!=5):
				await frame_changed
			for body in parent.get_node("SwordAttackArea").get_overlapping_bodies():
				#TODO: Add attack logic
				pass
			await animation_looped
			p.change_state(p.states.IDLE)
		p.states.RUN_ATTACK:
			play("running_attack")
			while(frame!=5):
				await frame_changed
			for body in parent.get_node("SwordAttackArea").get_overlapping_bodies():
				#TODO: Add attack logic
				pass
			await animation_looped
			p.change_state(p.states.RUN)
