extends Control

func _on_Back_pressed():
	Transition.change_scene(Global.MainMenu)

func _on_DoomsdayTutorial_pressed():
	Transition.change_scene(Global.DoomsdaySurferTutorial)

func _on_CollectorTutorial_pressed():
	Transition.change_scene(Global.PowerCollectorTutorial)

func _on_SurvivorsTutorial_pressed():
	Transition.change_scene(Global.SurvivorsTutorial)

func _on_KaijuPlantTutorial_pressed():
	Transition.change_scene(Global.KaijuPlantTutorial)
