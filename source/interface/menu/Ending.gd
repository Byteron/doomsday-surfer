extends Node2D

func _on_Button_pressed():
	get_tree().quit()
	
func _on_Button2_pressed():
	Global.game_time += 30
	get_tree().change_scene(Global.Game)

