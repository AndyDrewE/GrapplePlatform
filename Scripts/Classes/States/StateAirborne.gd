class_name StateAirborne extends State


## Called by the state machine on the engine's physics update tick.
func physics_update(delta: float) -> void:
	#Cap vertical velocity
	if actor.velocity.y >= actor.TERMINAL_VELOCITY:
		actor.velocity.y = actor.TERMINAL_VELOCITY
	else:
		actor.velocity.y += actor.gravity * delta
	
	#If player releases jump, reverse velocity and slow it down
	if Input.is_action_just_released("ui_accept") and not actor.is_on_floor():
		if actor.velocity.y < 0:
			actor.velocity.y = -actor.velocity.y*0.5
	
	
	if Input.is_action_just_pressed("ui_shoot"):
		finished.emit(self, "StateGrappling")
	
	if actor.is_on_wall_only():
		finished.emit(self, "StateWallSlide")
	
	if actor.is_on_floor():
		finished.emit(self, "StateGrounded")
