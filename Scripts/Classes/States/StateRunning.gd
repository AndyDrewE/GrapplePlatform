extends State
class_name StateRunning

##TODO: Make a signal that can tell this state when to turn off for the split second so the wall slide can do it's thing

## Called by the state machine on the engine's physics update tick.
func physics_update(_delta: float) -> void:
	
	var direction = Input.get_axis("ui_left", "ui_right")
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
	print("lock x axis movement")
