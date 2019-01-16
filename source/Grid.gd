extends TileMap

const WIDTH = 4
const HEIGHT = 4
const OFFSET = Vector2(64, 64)

var locations = {}

func _ready():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			x += 1
			locations[_flatten(Vector2(x, y))] = {
				cell = Vector2(x, y),
				position = map_to_world_centered(Vector2(x, y)),
				unit = null,
			}

func map_to_world_centered(cell):
	return map_to_world(cell) + OFFSET

func get_unit_at(cell):
	return locations[_flatten(cell)].unit

func set_unit_at(unit, cell):
	locations[_flatten(cell)].unit = unit

func _flatten(cell):
	return int(cell.y) * WIDTH + int(cell.x) 
	


