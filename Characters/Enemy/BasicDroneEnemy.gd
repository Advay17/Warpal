class_name BasicDroneEnemy extends GenericEnemy
enum states{IDLE, PATH_TO_TARGET, IN_RANGE_OF_TARGET, RETURNING_TO_LOCATION}
var state=states.IDLE
func _physics_process(delta):
	super(delta)


func _on_player_found():
	state=states.PATH_TO_TARGET


func _on_player_lost():
	state=states.RETURNING_TO_LOCATION
