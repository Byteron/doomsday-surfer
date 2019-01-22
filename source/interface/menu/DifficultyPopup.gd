extends Popup

func _on_Tutorial_pressed():
	Transition.change_scene(Global.Controls)

func _on_Easy_pressed():
	Difficulty.easy()
	Transition.change_scene(Global.Story)

func _on_Medium_pressed():
	Difficulty.medium()
	Transition.change_scene(Global.Story)

func _on_Hard_pressed():
	Difficulty.hard()
	Transition.change_scene(Global.Story)