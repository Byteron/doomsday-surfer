extends Control

func _on_Button_pressed():
	Transition.change_scene(Global.Sold)

func _on_Button2_pressed():
	Transition.change_scene(Global.MainMenu)