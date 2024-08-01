extends HitboxSprite

@onready var p:GravityCharacter=get_parent()
# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if p.facing_right:
		flip_h=false
	else:
		flip_h=true






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
