extends KinematicBody2D

# temp reset point level 1 only
onready var debug_reset_position = get_node("../DebugResetPoint")

var motion = Vector2(0,0)
var lastPressed
var is_jumping

# Godot doesn't know what 'up' is. This determines if something is a floor etc..
const UP = Vector2(0,-1)

const SPEED = 1300
const GRAVITY = 100
const JUMP_SPEED = 1700

signal animate



func _physics_process(delta):
	# world effects and interactions
	apply_gravity()
	animate()
	
	# player actions
	jump()
	move()
	

	#debug actions
	reset_player()
	
	# move_and_slide needs to know what UP is to have floor logic work
	move_and_slide(motion, UP)
	
func apply_gravity():
	if not is_on_floor():
		# Have gravity affect player
		motion.y += GRAVITY
	else:
		motion.y = 0
		

func reset_player():
	if Input.is_action_just_released("debug_reset"):
		motion.y = 0
		set_position(debug_reset_position.get_position())
	
func jump():
	if is_on_floor():
		is_jumping = false
	if Input.is_action_pressed("jump") and is_on_floor():
		is_jumping=true
		motion.y -= JUMP_SPEED	

func move():
	# if player presses the opposite direction while still holding previous direction:
	# make bunny go in opposite direction
	if Input.is_action_pressed("left") and Input.is_action_pressed("right"):
		if motion.x >0 and lastPressed == "right":
			motion.x=-SPEED
		elif motion.x <0 and lastPressed == "left":
			motion.x=SPEED
	elif Input.is_action_pressed("left"):
		lastPressed = "left"
		motion.x=-SPEED
	elif Input.is_action_pressed("right"):
		lastPressed = "right"
		motion.x=SPEED
	else:
		motion.x=0
		
func animate():
	# Sends signal to PlayerAnimation to animate based on motion and is_jumping
	emit_signal("animate", motion, is_jumping)

