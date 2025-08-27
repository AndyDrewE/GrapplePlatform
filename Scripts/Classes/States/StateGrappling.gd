class_name StateGrappling extends State

var grapple_point
var rope_length = 0.0

## Called by the state machine upon changing the active state.
func enter() -> void:
	print("grapple")
	grapple()

## Called by the state machine before changing the active state. Use this function
## to clean up the state.
func exit() -> void:
	release_grapple()

## Called by the state machine on the engine's physics update tick.
func physics_update(delta: float) -> void:
	var r2 = actor.global_position - grapple_point
	var d2 = r2.length()
	if d2 > rope_length:
		actor.global_position = grapple_point + r2.normalized() * rope_length
	actor.grapple_rope.points = [actor.to_local(actor.position), actor.to_local(grapple_point)]
	
	var direction = Input.get_axis("ui_left", "ui_right")
	var r = actor.global_position - grapple_point
	var dist = max(r.length(), 0.001)
	var dir = r / dist                     # from anchor -> player
	var tangent = Vector2(dir.y, dir.x)   # 90° to the rope
	
	# Pump the swing with left/right as tangential acceleration
	actor.velocity += tangent * (direction * actor.TANGENTIAL_ACCEL * delta)

	# Remove outward radial velocity when rope is taut (keeps circular motion)
	var v_radial = actor.velocity.dot(dir)
	if dist >= rope_length and v_radial > 0.0:
		actor.velocity -= dir * v_radial
	
	
	if Input.is_action_pressed("grapple_reel_in"):
		rope_length = max(10.0, rope_length - actor.REEL_SPEED * delta)
	elif Input.is_action_pressed("grapple_reel_out"):
		rope_length = min(actor.MAX_GRAPPLE_DIST, rope_length + actor.REEL_SPEED * delta)
			
	if Input.is_action_just_pressed("ui_shoot"):
		finished.emit(self, "StateAirborne")
	if actor.is_on_floor():
		finished.emit(self, "StateGrounded")

func grapple():
	# Aim the ray in LOCAL space, then cast once
	var to_mouse_local = actor.grapple_raycast.to_local(actor.get_global_mouse_position())
	if to_mouse_local.length() > actor.MAX_GRAPPLE_DIST:
		to_mouse_local = to_mouse_local.normalized() * actor.MAX_GRAPPLE_DIST
	actor.grapple_raycast.target_position = to_mouse_local
	actor.grapple_raycast.enabled = true
	actor.grapple_raycast.force_raycast_update()

	if actor.grapple_raycast.is_colliding():
		grapple_point = actor.grapple_raycast.get_collision_point()
		var collision_normal = actor.grapple_raycast.get_collision_normal()
		#check if collision is on bottom
		if collision_normal.y == 1:
			rope_length = (actor.global_position - grapple_point).length()
		
	# turn the node off regardless; we only needed it to find the hit
	actor.grapple_raycast.enabled = false

func release_grapple():
	actor.grapple_rope.points = []
