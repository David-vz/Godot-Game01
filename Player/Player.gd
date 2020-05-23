extends KinematicBody2D

# temp reset point level 1 only
onready var debug_reset_position = get_node("../DebugResetPoint")

var motion = Vector2(0,0)
var lastPressed

var is_jumping
var buffer_jump = false
var buffer_platform = false
var pressed_jump_timer = null
var on_platform_timer = null



# Godot doesn't know what 'up' is. This determines if something is a floor etc..
const UP = Vector2(0,-1)

const SPEED = 1000
const GRAVITY = 100
const JUMP_SPEED = 1900

signal animate

func _ready():
	# Jump pressed timer setup
	pressed_jump_timer = Timer.new()
	pressed_jump_timer.set_timer_process_mode(1)
	pressed_jump_timer.set_one_shot(true)
	pressed_jump_timer.set_wait_time(0.15)
	pressed_jump_timer.connect("timeout", self, "on_pressed_jump_timeout")
	# Adds timer to process
	add_child(pressed_jump_timer)
	
	# Platform left timer setup
	on_platform_timer = Timer.new()
	on_platform_timer.set_timer_process_mode(1)
	on_platform_timer.set_one_shot(true)
	on_platform_timer.set_wait_time(0.12)
	on_platform_timer.connect("timeout", self, "on_platform_timeout")
	# Adds timer to process
	add_child(on_platform_timer)



func _physics_process(delta):
	print(on_platform_timer.get_time_left())
	
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
	if is_on_floor():
		# Have gravity affect player
		motion.y = 0
	elif is_on_ceiling():
		motion.y = GRAVITY
	else:
		motion.y += GRAVITY
		

func reset_player():
	if Input.is_action_just_released("debug_reset"):
		motion.y = 0
		set_position(debug_reset_position.get_position())
	
func jump():
	# Timer check for remembering jump press just before hitting the ground
	if Input.is_action_just_pressed("jump"):
		pressed_jump_timer.start()
		buffer_jump = true
	
	
	if is_on_floor():
		is_jumping = false
		buffer_platform = true
		on_platform_timer.start()
		
#		
	if (Input.is_action_just_pressed("jump") and (is_on_floor() or buffer_platform==true)) or (is_on_floor() and buffer_jump == true) :
		is_jumping=true
		motion.y = -JUMP_SPEED
		buffer_platform = false
		buffer_jump = false
	

# when timeout finishes, forget jump button was pressed recently
func on_pressed_jump_timeout():
	buffer_jump = false
	
# when timeout finishes, forget player was on platform recently
func on_platform_timeout():
	buffer_platform = false
	print('completed jump buffer')
	

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

