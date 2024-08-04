extends Node2D
@onready var p:PlayerCharacter=get_parent()
@onready var s:HitboxSprite=get_parent().get_node("Sprite")
var telebolt=preload("res://Characters/Player/TeleBolt/tele_bolt.tscn")


func _on_player_character_state_change(state):
	match(state):
		p.states.IDLE:
			s.play("default")
		p.states.RUN:
			s.play("run")
		p.states.ROLL:
			s.play("roll")
			await s.animation_looped
			p.change_state(p.states.RUN)
		p.states.STILL_ATTACK:
			s.play("standing_attack")
			while(s.frame!=5):
				if(s.animation!="standing_attack"):
					return
				await s.frame_changed
			for body in p.get_node("SwordAttackArea").get_overlapping_bodies():
				#TODO: Add attack logic
				pass
			await s.animation_looped
			p.change_state(p.states.IDLE)
		p.states.RUN_ATTACK:
			s.play("running_attack")
			while(s.frame!=5):
				if(s.animation!="running_attack"):
					return
				await s.frame_changed
			for body in p.get_node("SwordAttackArea").get_overlapping_bodies():
				#TODO: Add attack logic
				pass
			await s.animation_looped
			p.change_state(p.states.RUN)
		p.states.BOLT:
			if(abs(rad_to_deg(position.angle_to(get_local_mouse_position())))<60):
				s.play("throw_down")
				await s.animation_looped
				var bolt = telebolt.instantiate()
				p.add_child(bolt)
				p.change_state(p.states.RUN)
				pass
			elif (abs(rad_to_deg(position.angle_to(get_local_mouse_position())))<120):
				s.play("throw_straight")
				await s.animation_looped
				var bolt = telebolt.instantiate()
				p.add_child(bolt)
				p.change_state(p.states.RUN)
			else:
				s.play("throw_up")
				await s.animation_looped
				var bolt = telebolt.instantiate()
				p.add_child(bolt)
				p.change_state(p.states.RUN)
