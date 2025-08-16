extends CharacterBody2D


@export var SPEED = 150.0
@export var JUMP_VELOCITY = -500.0
const MAX_GRAPPLE_DIST = 700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Grapple Raycast Object
@onready var grapple_raycast = $GrappleRay
var grappling = false

func _input(event):
	if event.is_action_pressed("ui_shoot"):
		# Aim from the RayCast2D's origin toward the mouse, in LOCAL space.
		var to_mouse_local = grapple_raycast.to_local(get_global_mouse_position())
		# Clamp to a max distance so the ray isn't absurdly long.
		if to_mouse_local.length() > MAX_GRAPPLE_DIST:
			to_mouse_local = to_mouse_local.normalized() * MAX_GRAPPLE_DIST
		grapple_raycast.target_position = to_mouse_local
		
		grapple_raycast.enabled = true
		grappling = true

func _physics_process(delta):
	if grappling:
		grapple_raycast.force_raycast_update()

		if grapple_raycast.is_colliding():
			var hit_point = grapple_raycast.get_collision_point()
			var hit_body = grapple_raycast.get_collider()
			print("Grapple hit:", hit_body, "at", hit_point)

			# turn off ray until next shot
			grapple_raycast.enabled = false
			grappling = false
	
	if grapple_raycast.is_colliding():
		var collision_point = grapple_raycast.get_collision_point()
		print("Collision point: ", collision_point)
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += JUMP_VELOCITY

	if Input.is_action_just_released("ui_accept") and not is_on_floor() and velocity.y < 0:
		velocity.y = -velocity.y*0.5

	velocity.y += gravity * delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
