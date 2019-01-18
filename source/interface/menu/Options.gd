extends Control

func _on_Button_pressed():
	print("Soul sold")
	get_tree().change_scene(Global.Sold)

func _on_Button2_pressed():
	print("Soul Kept")
	get_tree().change_scene(Global.MainMenu)