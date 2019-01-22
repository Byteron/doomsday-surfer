extends Popup

func _on_Tutorial_pressed():
	print("Tutorial")

func _on_Easy_pressed():
	Difficulty.easy()
	Transition.change_scene(Global.Story)

func _on_Medium_pressed():
	Difficulty.medium()
	Transition.change_scene(Global.Story)

func _on_Hard_pressed():
	Difficulty.hard()
	Transition.change_scene(Global.Story)