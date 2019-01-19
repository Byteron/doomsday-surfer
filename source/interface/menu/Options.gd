extends Control

func _on_Button_pressed():
	print("Soul sold")
	Transition.change_scene(Global.Sold)

func _on_Button2_pressed():
	print("Soul Kept")
	Transition.change_scene(Global.MainMenu)