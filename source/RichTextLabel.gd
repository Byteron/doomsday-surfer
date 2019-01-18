extends RichTextLabel

func _process(delta):
	if $Read_time.time_left == 0:
		get_tree().change_scene(Global.Game)