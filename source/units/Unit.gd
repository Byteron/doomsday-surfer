extends AnimatedSprite

signal killed_enemy_kaiju()
signal power_cell_collected()

var location = null

func initialize(loc):
	move_to(loc)

func move_to(loc):
	if self.location:
		self.location.unit = null
	self.location = loc
	self.position = location.position
	location.unit = self
	power_collector(loc)
	kaiju_plant(loc)

func select():
	scale = Vector2(1.3, 1.3)

func unselect():
	scale = Vector2(1, 1)

func power_collector(loc):
	if name == "PowerCollector":
		if loc.power_cell:
			loc.power_cell.queue_free()
			loc.power_cell = null
			emit_signal("power_cell_collected")

func kaiju_plant(loc):
	if name == "KaijuPlant":
		if loc.enemy:
			emit_signal("killed_enemy_kaiju", loc)