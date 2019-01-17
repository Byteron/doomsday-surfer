extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
		# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if $Read_time.time_left == 0:
		get_tree().change_scene(Global.Game)
#	pass