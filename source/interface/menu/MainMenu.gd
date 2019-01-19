extends Node

func _on_Button_pressed():
	print("StartGame pressed")
	Transition.change_scene(Global.Story)

func _on_Button2_pressed():
	print("Options pressed")
	get_tree().change_scene(Global.Options)

func _on_Button3_pressed():
	print("Exit pressed")
	get_tree().quit()

