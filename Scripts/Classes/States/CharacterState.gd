class_name CharacterState extends State

func jump_impulse():
	if actor.is_on_floor():
			actor.velocity.y = actor.JUMP_VELOCITY

func handle_horizontal_movement():
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		actor.velocity.x = direction * actor.SPEED
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

func gravity(delta):
	#Cap vertical velocity
	if actor.velocity.y >= actor.TERMINAL_VELOCITY:
		actor.velocity.y = actor.TERMINAL_VELOCITY
	else:
		actor.velocity.y += actor.gravity * delta
