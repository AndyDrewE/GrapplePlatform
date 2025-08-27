class_name StateIdle extends CharacterState

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if Input.get_axis("ui_left", "ui_right"):
		finished.emit(self, "StateRunning")
	
	if Input.is_action_just_pressed("ui_accept"):
		jump_impulse()
	
	if Input.is_action_just_pressed("ui_shoot"):
		finished.emit(self, "StateGrappling")
	
	if not actor.is_on_floor():
		finished.emit(self, "StateAirborne")
