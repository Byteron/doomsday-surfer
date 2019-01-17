extends Node

func _on_Button_pressed():
	print("StartGame pressed")
	get_tree().change_scene("res://source/Game.tscn")

func _on_Button2_pressed():
	print("Options pressed")
	#get_tree().change_scene("PATH TO OPTINS GOES HERE")

func _on_Button3_pressed():
	print("Exit pressed")
	get_tree().quit()

