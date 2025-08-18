extends CharacterBody2D

## TODO: Dynamic camera smoothing as player gets faster
## TODO: Grappling hook

@export var SPEED = 150.0
@export var JUMP_VELOCITY = -500.0
@export var TERMINAL_VELOCITY = 1000.0
const MAX_GRAPPLE_DIST = 700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Grappling hook
@onready var grapple_raycast = $GrappleRay
var grappling = false

func _input(event):
	pass

func _physics_process(delta):
	grapple()
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y += JUMP_VELOCITY
	#If player releases jump, reverse velocity and slow it down
	if Input.is_action_just_released("ui_accept") and not is_on_floor() and velocity.y < 0:
		velocity.y = -velocity.y*0.5

	#Cap vertical velocity
	if velocity.y >= TERMINAL_VELOCITY:
		velocity.y = TERMINAL_VELOCITY
	else:
		velocity.y += gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func grapple():
	grapple_raycast.target_position = get_global_mouse_position()
	if Input.is_action_just_pressed("ui_shoot"):
		print(grapple_raycast.target_position)
