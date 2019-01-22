extends Control

func _on_Back_pressed():
	Transition.change_scene(Global.MainMenu)


func _on_DoomsdayTutorial_pressed():
	Transition.change_scene(Global.DoomsdaySurferTutorial)
	pass # replace with function body
