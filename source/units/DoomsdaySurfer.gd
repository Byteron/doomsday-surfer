extends "res://source/units/Unit.gd"

signal surfer_moved(quadrant)
signal timeout()

var last_quadrant = null

func move_to(loc):
	.move_to(loc)
	surfer(loc)

func set_surfing_time(time):
	$QuadrantFreezeTimer.wait_time = time

func surfer(loc):
	if last_quadrant != loc.quadrant:
		var last = last_quadrant
		last_quadrant = loc.quadrant
		$QuadrantFreezeTimer.start()
		play("surfing")
		offset = Vector2(16, 16)
		emit_signal("surfer_moved", last, loc.quadrant)

func _on_QuadrantFreezeTimer_timeout():
	emit_signal("timeout", location.quadrant)
	play("idle")
	offset = Vector2(25, -25)
