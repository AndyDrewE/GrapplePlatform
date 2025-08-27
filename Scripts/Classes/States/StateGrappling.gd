class_name StateGrappling extends CharacterState

var grapple_point : Vector2 = Vector2.ZERO
var rope_length = 0.0

## Called by the state machine upon changing the active state.
func enter() -> void:
	if not grapple():
		#No valid hook point
		finished.emit(self, "StateAirborne")

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	release_grapple()

## Called by the state machine on the engine's physics update tick.
func physics_update(delta: float) -> void:
	if grapple_point == Vector2.ZERO:
		finished.emit(self, "StateAirborne")
		return
	
	gravity(delta)
	
	var r = actor.global_position - grapple_point
	var dist = max(r.length(), 0.001)
	var dir = r/dist
	var tangent = Vector2(dir.y, dir.x)
	
	#enforce rope length
	if dist > rope_length:
		actor.global_position = grapple_point + dir * rope_length
	
	#draw rope
	actor.grapple_rope.points = [Vector2.ZERO, actor.to_local(grapple_point)]
	
	#pump swing left and right
	var input_dir = Input.get_axis("ui_left", "ui_right")
	if input_dir:
		actor.velocity += tangent * (input_dir * actor.TANGENTIAL_ACCEL * delta)

	# Remove outward radial velocity when rope is taut (keeps circular motion)
	var v_radial = actor.velocity.dot(dir)
	if dist >= rope_length and v_radial > 0.0:
		actor.velocity -= dir * v_radial
	
	# Reel
	if Input.is_action_pressed("grapple_reel_in"):
		rope_length = max(10.0, rope_length - actor.REEL_SPEED * delta)
	elif Input.is_action_pressed("grapple_reel_out"):
		rope_length = min(actor.MAX_GRAPPLE_DIST, rope_length + actor.REEL_SPEED * delta)

	#Release
	if Input.is_action_just_pressed("ui_shoot"):
		finished.emit(self, "StateAirborne")

func grapple():
	actor.grapple_raycast.enabled = true
	
	# Aim the ray in LOCAL space, then cast once
	var to_mouse_local = actor.grapple_raycast.to_local(actor.get_global_mouse_position())
	if to_mouse_local.length() > actor.MAX_GRAPPLE_DIST:
		to_mouse_local = to_mouse_local.normalized() * actor.MAX_GRAPPLE_DIST
	actor.grapple_raycast.target_position = to_mouse_local
	
	#query immediately
	actor.grapple_raycast.force_raycast_update()
	var hit = actor.grapple_raycast.is_colliding()
	if hit:
		grapple_point = actor.grapple_raycast.get_collision_point()
		var collision_normal = actor.grapple_raycast.get_collision_normal()
		#check if collision is on bottom
		if collision_normal.y == 1:
			rope_length = (actor.global_position - grapple_point).length()
		
	# turn the node off regardless; we only needed it to find the hit
	actor.grapple_raycast.enabled = false
	return hit

func release_grapple():
	grapple_point = Vector2.ZERO
	actor.grapple_rope.points = []
