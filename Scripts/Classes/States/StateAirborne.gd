class_name StateAirborne extends State

## Called by the state machine when receiving unhandled input events.
func handle_input(_event: InputEvent) -> void:
	pass

## Called by the state machine on the engine's main loop tick.
func update(_delta: float) -> void:
	pass

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	#If player releases jump, reverse velocity and slow it down
	if Input.is_action_just_released("ui_accept") and not actor.is_on_floor():
		if actor.velocity.y < 0:
			actor.velocity.y = -actor.velocity.y*0.5
	
	if actor.is_on_wall_only():
		finished.emit(self, "StateWallSlide")
	
	if actor.is_on_floor():
		finished.emit(self, "StateGrounded")
