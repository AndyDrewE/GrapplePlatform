extends CharacterState
class_name StateRunning

## Called by the state machine on the engine's physics update tick.
func physics_update(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	
	handle_horizontal_movement()
	
	if Input.is_action_just_pressed("ui_accept"):
		jump_impulse()
	
	if Input.is_action_just_pressed("ui_shoot"):
		finished.emit(self, "StateGrappling")
	
	if not actor.is_on_floor():
		finished.emit(self, "StateAirborne")
	
	if !direction:
		finished.emit(self, "StateIdle")

## Called by the state machine upon changing the active state.
func enter() -> void:
	pass
