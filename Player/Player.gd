extends KinematicBody2D

var motion = Vector2(0,0)
var lastPressed

const SPEED = 500

func _physics_process(delta):
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
	move_and_slide(motion)
