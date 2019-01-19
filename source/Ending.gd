extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_exit_pressed():
	get_tree().quit()
	pass # replace with function body


func _on_replay_pressed():
	get_tree().change_scene(Global.Game)
	pass # replace with function body


func _on_show_timeout():
	$buttons.show()
	pass # replace with function body
