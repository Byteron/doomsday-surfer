extends Node2D

onready var marker = $Marker

func start_marker():
	marker.animate()

func reset_marker():
	marker.stop()
	marker.reset()

func update_marker_position(position):
	marker.position = position