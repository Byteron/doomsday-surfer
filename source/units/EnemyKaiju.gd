extends AnimatedSprite

signal killed_unit(loc)

var location = null

func initialize(loc):
	location = loc
	position = location.position
	location.enemy = self
	kill_unit(loc)

func move_to(loc):
	self.location.enemy = null
	self.location = loc
	self.position = location.position
	location.enemy = self
	kill_unit(loc)
	
func kill_unit(loc):
	if loc.unit:
		emit_signal("killed_unit", loc)