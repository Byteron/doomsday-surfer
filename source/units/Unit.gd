extends AnimatedSprite

signal power_cell_collected()
signal surfer_moved(quadrant)

var location = null

func initialize(loc):
	self.location = loc
	position = location.position
	location.unit = self

func move_to(loc):
	self.location.unit = null
	self.location = loc
	self.position = location.position
	location.unit = self
	power_collector(loc)
	surfer(loc)

func power_collector(loc):
	if name == "PowerCollector":
		if loc.power_cell:
			loc.power_cell.queue_free()
			loc.power_cell = null
			emit_signal("power_cell_collected")

func surfer(loc):
	if name == "DoomsdaySurfer":
		emit_signal("surfer_moved", loc.quadrant)
		print(loc.quadrant)