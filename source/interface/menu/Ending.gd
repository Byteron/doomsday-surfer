extends Node2D

func _on_exit_pressed():
	get_tree().quit()


func _on_replay_pressed():
	Transition.change_scene(Global.Game)


func _on_show_timeout():
	$buttons.show()
