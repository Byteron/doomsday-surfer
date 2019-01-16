extends Node

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


func _on_Button_pressed():
	print("StartGame pressed")
	get_tree().change_scene("res://source/Game.gd")

func _on_Button2_pressed():
	print("Options pressed")
	#get_tree().change_scene("PATH TO OPTINS GOES HERE")

func _on_Button3_pressed():
	print("Exit pressed")
	get_tree().quit()

