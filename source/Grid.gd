extends TileMap

const WIDTH = 6
const HEIGHT = 4
const OFFSET = Vector2(64, 64)

var quadrants = {}
var locations = {}

func _ready():
	setup_locations()
	setup_quadrants()

func setup_locations():
	for y in range(HEIGHT):
		for x in range(WIDTH):
			locations[_flatten(Vector2(x, y))] = {
				quadrant = null,
				cell = Vector2(x, y),
				position = map_to_world_centered(Vector2(x, y)),
				unit = null,
				disaster = null,
				power_cell = null
			}

func setup_quadrants():
	quadrants = [
		{
			name = "Tsunami Quadrant",
			level = 0, 
			locations = [
				get_location_at(Vector2(2, 1)),
				get_location_at(Vector2(1, 1)),
				get_location_at(Vector2(2, 0)),
				get_location_at(Vector2(1, 0))
			]
		},
		{
			name = "Lava Quadrant",
			level = 0,
			locations = [
				get_location_at(Vector2(4, 1)),
				get_location_at(Vector2(3, 1)),
				get_location_at(Vector2(4, 0)),
				get_location_at(Vector2(3, 0))
			]
		},
		{
			name = "Earthquake Quadrant",
			level = 0,
			locations = [
				get_location_at(Vector2(2, 3)),
				get_location_at(Vector2(1, 3)),
				get_location_at(Vector2(2, 2)),
				get_location_at(Vector2(1, 2))
			]
		},
		{
			name = "Tornado Quadrant",
			level = 0,
			locations = [
				get_location_at(Vector2(4, 3)),
				get_location_at(Vector2(3, 3)),
				get_location_at(Vector2(4, 2)),
				get_location_at(Vector2(3, 2))
			]
		}
	]
	
	var i = 1
	for quadrant in quadrants:
		for loc in quadrant.locations:
			loc.quadrant = i
		i += 1

func map_to_world_centered(cell):
	return map_to_world(cell) + OFFSET

func get_unit_at(cell):
	return locations[_flatten(cell)].unit

func get_location_at(cell):
	return locations[_flatten(cell)]

func get_quadrant_location(quadrant_index, location_index):
	return quadrants[quadrant_index].locations[location_index]

func get_quadrant_level(quadrant_index):
	return quadrants[quadrant_index].level

func increase_quadrant_level(quadrant_index):
	quadrants[quadrant_index].level += 1

func reset_quadrant_level(quadrant_index):
	quadrants[quadrant_index].level = 0

func set_unit_at(unit, cell):
	locations[_flatten(cell)].unit = unit

func _flatten(cell):
	return int(cell.y) * WIDTH + int(cell.x) 
	


