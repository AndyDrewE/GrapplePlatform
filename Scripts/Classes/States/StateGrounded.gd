class_name StateGrounded extends State

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		jump_impulse()
		finished.emit(self, "StateAirborne")
		return
		
	if not actor.is_on_floor():
		finished.emit(self, "StateAirborne")
		return


func jump_impulse():
	if actor.is_on_floor():
			actor.velocity.y = actor.JUMP_VELOCITY
