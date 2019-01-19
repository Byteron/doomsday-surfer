extends Node

func _on_Button_pressed():
	Transition.change_scene(Global.Story)

func _on_Button2_pressed():
	get_tree().change_scene(Global.Options)

func _on_Button3_pressed():
	get_tree().quit()

