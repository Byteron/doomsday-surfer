extends Node2D

onready var marker = $Marker

func start_marker():
	print(name, ": start_marker")
	marker.animate()

func reset_marker():
	print(name, ": reset marker")
	marker.stop()
	marker.reset()

func update_marker_position(position):
	marker.position = position