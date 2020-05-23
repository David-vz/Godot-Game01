extends Control

func _process(delta):
	if Input.is_action_just_pressed("jump"):
		restart()

func _on_RestartButton_pressed():
	restart()
	
func restart():
	get_tree().change_scene("res://Levels/Level1.tscn")
