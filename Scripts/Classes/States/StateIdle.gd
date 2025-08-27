class_name StateIdle extends State

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if Input.get_axis("ui_left", "ui_right"):
		finished.emit(self, "StateRunning")
