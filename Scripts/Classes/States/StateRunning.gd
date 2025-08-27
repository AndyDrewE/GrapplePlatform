extends State
class_name StateRunning

func _ready():
	if not actor.is_connected("wall_jump", _on_wall_jump):
		actor.wall_jump.connect(_on_wall_jump)
		print("wall_jump signal connected")

## Called by the state machine on the engine's physics update tick.
func physics_update(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if actor.wall_jump_timer > 0.0:
		actor.wall_jump_timer -= delta
	else:
		if direction:
			actor.velocity.x = direction * actor.SPEED
		else:
			actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	if !direction:
		finished.emit(self, "StateIdle")

## Called by the state machine upon changing the active state.
func enter() -> void:
	pass

func _on_wall_jump():
	actor.wall_jump_timer = actor.WALL_JUMP_LOCK
