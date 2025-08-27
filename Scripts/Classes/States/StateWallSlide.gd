class_name StateWallSlide extends CharacterState

## Called by the state machine on the engine's physics update tick.
func physics_update(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		actor.wall_jump_timer = actor.WALL_JUMP_LOCK
		actor.velocity = Vector2(actor.get_wall_normal().x * actor.WALL_JUMP_PUSHBACK, actor.JUMP_VELOCITY)
		finished.emit(self, "StateAirborne")
		return
	
	actor.velocity.y = min(actor.velocity.y + actor.gravity * delta, actor.wall_slide_gravity)
	
	if actor.is_on_floor():
		finished.emit(self, "StateIdle")
		return
	else:
		if not actor.is_on_wall():
			finished.emit(self, "StateAirborne")
			return
	
