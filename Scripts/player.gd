extends CharacterBody2D

## TODO: Dynamic camera smoothing as player gets faster
## TODO: Grappling hook: keep tangential velocity when releasing the hook
## TODO: Some sort of UI to tell you where the grappling hook will land
## TODO: Grappling hook very hard to control with kbm


@export var SPEED = 150.0
@export var JUMP_VELOCITY = -500.0
@export var TERMINAL_VELOCITY = 1000.0
@export var REEL_SPEED = 300.0
@export var TANGENTIAL_ACCEL = 500.0
@export var MAX_GRAPPLE_DIST = 100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Grappling hook
@onready var grapple_raycast = $GrappleRay
@onready var grapple_rope = $GrappleRay/GrappleRope
var grappling = false
var grapple_point := Vector2.ZERO
var rope_length := 0.0

#Wall jump
@export var WALL_JUMP_PUSHBACK = 200
@export var WALL_JUMP_LOCK = 0.12
var wall_jump_timer = 0.0
@onready var wall_slide_gravity = gravity * 0.1

func _input(event):
	pass
	

func _physics_process(delta):
	jump()
	#Cap vertical velocity
	if velocity.y >= TERMINAL_VELOCITY:
		velocity.y = TERMINAL_VELOCITY
	else:
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if not grappling:
		if wall_jump_timer > 0.0:
			wall_jump_timer -= delta
		else:
			
	else:
		# --- Swing physics (rope constraint) ---
		var r = global_position - grapple_point
		var dist = max(r.length(), 0.001)
		var dir = r / dist                     # from anchor -> player
		var tangent = Vector2(dir.y, dir.x)   # 90° to the rope
	
		if Input.is_action_pressed("grapple_reel_in"):
			rope_length = max(10.0, rope_length - REEL_SPEED * delta)
		elif Input.is_action_pressed("grapple_reel_out"):
			rope_length = min(MAX_GRAPPLE_DIST, rope_length + REEL_SPEED * delta)
			
		# Pump the swing with left/right as tangential acceleration
		velocity += tangent * (direction * TANGENTIAL_ACCEL * delta)

		# Remove outward radial velocity when rope is taut (keeps circular motion)
		var v_radial := velocity.dot(dir)
		if dist >= rope_length and v_radial > 0.0:
			velocity -= dir * v_radial
			
	
		
	move_and_slide()
	
	#Handle Grappling
	if Input.is_action_just_pressed("ui_shoot"):
		if !grappling:
			grapple()
		else:
			release_grapple()
	
	if grappling:
		var r2 := global_position - grapple_point
		var d2 := r2.length()
		if d2 > rope_length:
			global_position = grapple_point + r2.normalized() * rope_length
		grapple_rope.points = [to_local(self.position), to_local(grapple_point)]

func grapple():
	# Aim the ray in LOCAL space, then cast once
	var to_mouse_local = grapple_raycast.to_local(get_global_mouse_position())
	if to_mouse_local.length() > MAX_GRAPPLE_DIST:
		to_mouse_local = to_mouse_local.normalized() * MAX_GRAPPLE_DIST
	grapple_raycast.target_position = to_mouse_local
	grapple_raycast.enabled = true
	grapple_raycast.force_raycast_update()

	if grapple_raycast.is_colliding():
		grapple_point = grapple_raycast.get_collision_point()
		var collision_normal = grapple_raycast.get_collision_normal()
		#check if collision is on bottom
		if collision_normal.y == 1:
			rope_length = (global_position - grapple_point).length()
			grappling = true
		
		
	# turn the node off regardless; we only needed it to find the hit
	grapple_raycast.enabled = false

func release_grapple():
	grappling = false
	grapple_rope.points = []

func get_grapple_direction():
	var direction = self.position.direction_to(get_global_mouse_position())
	var target_position = (direction * MAX_GRAPPLE_DIST) + self.position
	return target_position

func jump():
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"): 
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		#Wall Jump
		elif is_on_wall_only():
			velocity = Vector2(get_wall_normal().x * WALL_JUMP_PUSHBACK, JUMP_VELOCITY)
			wall_jump_timer = WALL_JUMP_LOCK
			
	
	if is_on_wall_only() and Input.get_axis("ui_left", "ui_right"):
		velocity.y = min(velocity.y, wall_slide_gravity)
	
	#If player releases jump, reverse velocity and slow it down
	if Input.is_action_just_released("ui_accept") and not is_on_floor():
		if velocity.y < 0:
			velocity.y = -velocity.y*0.5
