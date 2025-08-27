extends CharacterBody2D

## TODO: Dynamic camera smoothing as player gets faster
## TODO: Grappling hook: keep tangential velocity when releasing the hook
## TODO: Some sort of UI to tell you where the grappling hook will land
## TODO: Grappling hook very hard to control with kbm

signal wall_jump

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
var grapple_point := Vector2.ZERO
var rope_length := 0.0
var grappling = false

#Wall jump
@export var WALL_JUMP_PUSHBACK = 200
@export var WALL_JUMP_LOCK = 0.12
var wall_jump_timer = 0.0
@onready var wall_slide_gravity = gravity * 0.1

func _input(event):
	pass
	
func _physics_process(delta):
	move_and_slide()
