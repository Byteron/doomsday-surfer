extends Sprite

signal power_cell_collected()

var location = null

func initialize(data, loc):
	self.name = data.name
	self.texture = data.tex
	self.location = loc
	position = location.position
	location.unit = self

func move_to(loc):
	self.location.unit = null
	self.location = loc
	self.position = location.position
	location.unit = self
	power_collector(loc)

func power_collector(loc):
	if name == "PowerCollector":
		if loc.power_cell:
			loc.power_cell.queue_free()
			loc.power_cell = null
			emit_signal("power_cell_collected")