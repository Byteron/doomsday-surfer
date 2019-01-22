extends Control

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		Transition.change_scene(Global.Game)

func _on_Continue_pressed():
	Transition.change_scene(Global.Game)