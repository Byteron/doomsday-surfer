extends Control

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene(Global.Tutorial)

#func _process(delta):
#	if $Read_time.time_left == 0:
#		get_tree().change_scene(Global.Game)

func _on_Continue_pressed():
	get_tree().change_scene(Global.Tutorial)

