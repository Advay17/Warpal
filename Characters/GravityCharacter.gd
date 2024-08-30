class_name GravityCharacter extends CharacterBody2D


@export var speed = 300.0
@export var JUMP_VELOCITY = -400.0
signal turned
var facing_right=true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

func turn(p_facing_right:bool):
	if(facing_right!=p_facing_right):
		facing_right=p_facing_right
		for node in get_tree().get_nodes_in_group("Flippable"):
			node.position.x*=-1
		turned.emit()
