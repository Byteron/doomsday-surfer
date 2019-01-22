extends Node2D

onready var reason_label = $HBoxContainer/Reason

func _ready():
	if Global.defeat_reason:
		reason_label.text = Global.defeat_reason

func _on_Button_pressed():
		Transition.change_scene(Global.Game)

func _on_Button2_pressed():
	Transition.change_scene(Global.Game)
