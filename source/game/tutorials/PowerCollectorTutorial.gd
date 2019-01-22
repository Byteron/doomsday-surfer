extends "res://source/game/tutorials/Tutorial.gd"

var power_collector

func _ready():
	._ready()
	interface.hide_hunger_bar()
	interface.hide_breakpoint_bar()
	animate_markers()
	PowerCollector()
	get_tree().call_group("Timer", "start")
	interface.connect("energy_bar_charged", self, "_on_energy_bar_charged")
	popup_text.popup_centered("Power Collector", "The Power Collector gathers power cells to activate the CCC - The Clima Control Center.")

func PowerCollector():
	var unit = Global.PowerCollector.instance()
	power_collector = unit
	unit.connect("power_cell_collected", self, "_on_power_cell_collected")
	unit.initialize(grid.get_location_at(Vector2(1, 2)))
	units.add_child(unit)

func _on_Tsunami_timeout():
	if grid.get_quadrant_level(TSUNAMI) < 4:
		grid.increase_quadrant_level(TSUNAMI)
		var loc = grid.get_quadrant_location(TSUNAMI, grid.get_quadrant_level(TSUNAMI) - 1)
		var next_loc = grid.get_quadrant_location(TSUNAMI, grid.get_quadrant_level(TSUNAMI))
		if next_loc:
			tsunami_marker.position = next_loc.position
			tsunami_marker.animate()
		var disaster = Global.Disaster.instance()
		disaster.initialize(Global.tsunami_tex, loc.position)
		loc.disaster = disaster
		quadrants[TSUNAMI].add_child(disaster)
		_kill_unit(loc)
	_check_game_over()

func _on_Lava_timeout():
	if grid.get_quadrant_level(LAVA) < 4:
		grid.increase_quadrant_level(LAVA)
		var loc = grid.get_quadrant_location(LAVA, grid.get_quadrant_level(LAVA) - 1)
		var next_loc = grid.get_quadrant_location(LAVA, grid.get_quadrant_level(LAVA))
		if next_loc:
			lava_marker.position = next_loc.position
			lava_marker.animate()
		var disaster = Global.Disaster.instance()
		disaster.initialize(Global.lava_tex, loc.position)
		loc.disaster = disaster
		quadrants[LAVA].add_child(disaster)
		_kill_unit(loc)
	_check_game_over()

func _on_Earthquake_timeout():
	if grid.get_quadrant_level(EARTHQUAKE)  < 4:
		grid.increase_quadrant_level(EARTHQUAKE)
		var loc = grid.get_quadrant_location(EARTHQUAKE, grid.get_quadrant_level(EARTHQUAKE) - 1)
		var next_loc = grid.get_quadrant_location(EARTHQUAKE, grid.get_quadrant_level(EARTHQUAKE))
		if next_loc:
			earthquake_marker.position = next_loc.position
			earthquake_marker.animate()
		var disaster = Global.Disaster.instance()
		disaster.initialize(Global.earthquake_tex, loc.position)
		loc.disaster = disaster
		quadrants[EARTHQUAKE].add_child(disaster)
		_kill_unit(loc)
	_check_game_over()

func _on_Tornado_timeout():
	if grid.get_quadrant_level(TORNADO)  < 4:
		grid.increase_quadrant_level(TORNADO)
		var loc = grid.get_quadrant_location(TORNADO, grid.get_quadrant_level(TORNADO) - 1)
		var next_loc = grid.get_quadrant_location(TORNADO, grid.get_quadrant_level(TORNADO))
		if next_loc:
			tornado_marker.position = next_loc.position
			tornado_marker.animate()
		var disaster = Global.Disaster.instance()
		disaster.initialize(Global.tornado_tex, loc.position)
		loc.disaster = disaster
		quadrants[TORNADO].add_child(disaster)
		_kill_unit(loc)
	_check_game_over()

func _on_PowerCell_timeout():
	var free_locations = grid.get_free_locations()
	if free_locations.size() == 0:
		return
	randomize()
	var loc = free_locations[randi() % free_locations.size()]
	var power_cell = Global.PowerCell.instance()
	power_cell.position = loc.position
	loc.power_cell = power_cell
	items.add_child(power_cell)

func _on_energy_bar_charged():
	popup_text.popup_centered("Power Collector", "The Energy Bar is full! Now a quadrant will be resetted!")
	var quadrant_dict = grid.get_quadrant_with_highest_danger_level()
	var quadrant = quadrants[quadrant_dict.id]
	quadrant.update_marker_position(quadrant_dict.locations[0].position)
	quadrant.reset_marker()
	quadrant.start_marker()
	var quadrant_timer = _get_quadrant_timer(quadrant_dict.id)
	quadrant_timer.stop()
	quadrant_timer.start()
	for loc in quadrant_dict.locations:
		if loc.disaster:
			loc.disaster.queue_free()
			loc.disaster = null
	quadrant_dict.level = 0

func _on_power_cell_collected():
	popup_text.popup_centered("Power Collector", "You collected a power cell! Your energy bar filled up a bit. If it is full, the disasters of the area with the highest danger level (amount of disasters) will be removed!")
	interface.increase_power_level()