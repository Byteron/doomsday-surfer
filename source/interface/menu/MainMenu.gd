extends Node

onready var difficulty_popup = $DifficultyPopup

func _on_Button_pressed():
	difficulty_popup.popup_centered()

func _on_Button2_pressed():
	Transition.change_scene(Global.Options)

func _on_Button3_pressed():
	get_tree().quit()

func _on_Button4_pressed():
	Transition.change_scene(Global.Credits)
