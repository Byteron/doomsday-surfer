extends Sprite

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