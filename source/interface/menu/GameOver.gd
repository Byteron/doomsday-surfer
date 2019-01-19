extends Node2D

func _on_Button_pressed():
		Global.game_time = 60
		Transition.change_scene(Global.Game)

func _on_Button2_pressed():
	Transition.change_scene(Global.Tutorial)
