class_name StateIdle extends State

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if Input.get_axis("ui_left", "ui_right"):
		finished.emit(self, "StateRunning")

## Called by the state machine upon changing the active state.
func enter() -> void:
	#probably play an animation or something idk
	print("Idle")

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	pass
