extends TileMap

const WIDTH = 6
const HEIGHT = 4
const OFFSET = Vector2(64, 64)

var quadrants = {}
var locations = {}

var border_cells = [
	Vector2(0, 0), 
	Vector2(0, 1), 
	Vector2(0, 2), 
	Vector2(0, 3), 
	Vector2(5, 0), 
	Vector2(5, 1), 
	Vector2(5, 2), 
	Vector2(5, 3), 
]

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
				enemy = null,
				disaster = null,
				power_cell = null,
				food = null
			}

func setup_quadrants():
	quadrants = [
		{
			id = 0,
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
			id = 1,
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
			id = 2,
			name = "Earthquake Quadrant",
			level = 0,
			locations = [
				get_location_at(Vector2(4, 3)),
				get_location_at(Vector2(3, 3)),
				get_location_at(Vector2(4, 2)),
				get_location_at(Vector2(3, 2))
			]
		},
		{
			id = 3,
			name = "Tornado Quadrant",
			level = 0,
			locations = [
				get_location_at(Vector2(2, 3)),
				get_location_at(Vector2(1, 3)),
				get_location_at(Vector2(2, 2)),
				get_location_at(Vector2(1, 2))
			]
		}
	]
	
	var i = 0
	for quadrant in quadrants:
		for loc in quadrant.locations:
			loc.quadrant = i
		i += 1

func map_to_world_centered(cell):
	return map_to_world(cell) + OFFSET

func world_to_world(position):
	return map_to_world(world_to_map(position))

func get_unit_at(cell):
	return locations[_flatten(cell)].unit

func get_location_at(cell):
	return locations[_flatten(cell)]

func get_quadrant_location(quadrant_index, location_index):
	if quadrants[quadrant_index].locations.size() > location_index:
		return quadrants[quadrant_index].locations[location_index]
	return null

func get_quadrant_level(quadrant_index):
	return quadrants[quadrant_index].level

func get_quadrant_with_highest_danger_level():
	var danger_quadrant = quadrants[0]
	for quadrant in quadrants:
		if quadrant.level > danger_quadrant.level:
			danger_quadrant = quadrant
	return danger_quadrant

func get_free_locations():
	var free_locations = []
	for loc in locations.values():
		if not loc.unit and not loc.disaster and not loc.power_cell and not loc.food and not loc.cell in border_cells:
			free_locations.append(loc)
	return free_locations

func get_free_locations_enemy():
	var free_locations = []
	for loc in locations.values():
		if not loc.disaster and not loc.cell in border_cells:
			free_locations.append(loc)
	return free_locations

func get_free_locations_quadrant(quadrant):
	var free_locations =  []
	for loc in quadrants[quadrant].locations:
		if not loc.disaster:
			free_locations.append(loc)
	return free_locations

func increase_quadrant_level(quadrant_index):
	quadrants[quadrant_index].level += 1

func reset_quadrant_level(quadrant_index):
	quadrants[quadrant_index].level = 0

func set_unit_at(unit, cell):
	locations[_flatten(cell)].unit = unit

func _flatten(cell):
	return int(cell.y) * WIDTH + int(cell.x) 
	


