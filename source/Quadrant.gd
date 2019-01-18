extends Node2D

func clear():
	for child in get_children():
		child.queue_free()