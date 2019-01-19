extends Node2D

func _on_Button_pressed():
		Global.game_time = 60
		get_tree().change_scene(Global.Game)

func _on_Button2_pressed():
	get_tree().change_scene(Global.Tutorial)
