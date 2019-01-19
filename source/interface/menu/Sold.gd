extends Node2D

func _process(delta):
	if $Sold_out.time_left == 0:
		get_tree().quit()
	# Update game logic here.

