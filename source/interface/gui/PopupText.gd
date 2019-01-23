extends Popup

onready var text = $NinePatchRect/CenterContainer/VBoxContainer/Text

func popup_centered(title, text):
	set_text(text)
	popup()
	$Timer.start()

func set_text(text):
	self.text.bbcode_text = text

func _on_Timer_timeout():
	if visible == true:
		get_tree().paused = true

func _on_PopupText_popup_hide():
	get_tree().paused = false


func _on_Okay_pressed():
	print("okay pressed")
	hide()