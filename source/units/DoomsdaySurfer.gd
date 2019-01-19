extends "res://source/units/Unit.gd"

signal surfer_moved(quadrant)
signal timeout()

var last_quadrant = 10

func move_to(loc):
	.move_to(loc)
	surfer(loc)

func surfer(loc):
	if name == "DoomsdaySurfer":
		if last_quadrant != loc.quadrant:
			last_quadrant = loc.quadrant
			$QuadrantFreezeTimer.start()
			emit_signal("surfer_moved", loc.quadrant)

func _on_QuadrantFreezeTimer_timeout():
	emit_signal("timeout")
