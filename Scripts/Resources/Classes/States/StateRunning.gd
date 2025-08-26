extends State
class_name StateRunning

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if !direction:
		finished.emit(self, "StateIdle")

## Called by the state machine upon changing the active state.
func enter() -> void:
	#probably play an animation or something idk
	pass

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
