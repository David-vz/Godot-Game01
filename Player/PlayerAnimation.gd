extends AnimatedSprite



func _on_Player_animate(motion, is_jumping):
	if is_jumping:
		if motion.y>0:
			play("jump_down")
		else:
			play("jump_up")	
	elif motion.x != 0:
		if motion.x<0:
			flip_h=true
		else:
			flip_h=false
		play("walk")
	else:
		play("idle")
