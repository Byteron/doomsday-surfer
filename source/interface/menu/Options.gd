extends Control

func _on_Button_pressed():
	print("StartGame pressed")
	get_tree().change_scene(Global.Story)

func _on_Button2_pressed():
	print("Options pressed")
	get_tree().change_scene(Global.Options)