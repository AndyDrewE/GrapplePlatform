class_name StateWallSlide extends State

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	if Input.get_axis("ui_left","ui_right"):
		actor.velocity.y = min(actor.velocity.y, actor.wall_slide_gravity)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"): 
		actor.wall_jump.emit()
		actor.velocity = Vector2(actor.get_wall_normal().x * actor.WALL_JUMP_PUSHBACK, actor.JUMP_VELOCITY)
	
	if not actor.is_on_wall_only():
		if not actor.is_on_floor():
			finished.emit(self, "StateAirborne")
		else:
			finished.emit(self, "StateGrounded")
	
