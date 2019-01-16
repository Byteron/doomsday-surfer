extends Sprite

var location = null

func initialize(tex, loc):
	self.texture = tex
	self.location = loc

func move_to(loc):
	self.location.unit = null
	self.location = location
	self.position = location.position
	location.unit = self