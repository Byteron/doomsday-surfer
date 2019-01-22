extends Popup

onready var title = $NinePatchRect/CenterContainer/VBoxContainer/Title
onready var text = $NinePatchRect/CenterContainer/VBoxContainer/Text

func popup_centered(title, text):
	set_title(title)
	set_text(text)
	popup()
	$Timer.start()

func set_text(text):
	self.text.bbcode_text = text

func set_title(title):
	self.title.text = title

func _on_Timer_timeout():
	if visible == true:
		get_tree().paused = true

func _on_PopupText_popup_hide():
	get_tree().paused = false
