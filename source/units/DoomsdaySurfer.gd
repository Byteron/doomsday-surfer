extends "res://source/units/Unit.gd"

signal surfer_moved(quadrant)
signal timeout()

var last_quadrant = null

func move_to(loc):
	.move_to(loc)
	surfer(loc)

func surfer(loc):
	if last_quadrant != loc.quadrant:
		var last = last_quadrant
		last_quadrant = loc.quadrant
		$QuadrantFreezeTimer.start()
		play("surfing")
		offset = Vector2(16, 16)
		print("last ", last, "new ", last_quadrant)
		emit_signal("surfer_moved", last, loc.quadrant)

func _on_QuadrantFreezeTimer_timeout():
	emit_signal("timeout")
	play("idle")
	offset = Vector2(25, -25)
