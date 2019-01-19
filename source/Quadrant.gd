extends Node2D

onready var marker = $Marker

func clear():
	for child in get_children():
		child.queue_free()

func start_marker():
	marker.animate()

func reset_marker():
	marker.stop()
	marker.reset()

func update_marker_position(position):
	marker.position = position