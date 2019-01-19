extends Node2D

enum QUADRANT { TSUNAMI = 0, LAVA = 1, EARTHQUAKE = 2, TORNADO = 3}

var active_unit = null
var stopped_timer = null

var enemy_kaiju = null
var enemy_kaiju_marker = null

onready var tsunami_marker = $Q1/Marker
onready var lava_marker = $Q2/Marker
onready var earthquake_marker = $Q3/Marker
onready var tornado_marker = $Q4/Marker

onready var grid = $Grid
onready var units = $Units
onready var power_cells = $PowerCells
onready var food = $Food

onready var quadrants = [ $Q1, $Q2, $Q3, $Q4 ]

onready var tsunami_timer = $Timers/Tsunami
onready var lava_timer = $Timers/Lava
onready var earthquake_timer = $Timers/Earthquake
onready var tornado_timer = $Timers/Tornado

onready var power_cell_timer = $Timers/PowerCell
onready var food_timer = $Timers/Food
onready var interface = $Interface

func _unhandled_input(event):
	if event.is_action_pressed("click_left"):
		var mouse_cell = grid.world_to_map(get_local_mouse_position())
		var mouse_location = grid.get_location_at(mouse_cell)
		if active_unit:
			if not mouse_location.unit and not mouse_location.disaster:
				if mouse_location.enemy:
					if active_unit.name == "KaijuPlant":
						active_unit.move_to(mouse_location)
				else:
					active_unit.move_to(mouse_location)
			set_active_unit(null)
		elif not active_unit: 
			var unit = grid.get_unit_at(mouse_cell)
			set_active_unit(unit)
		print(mouse_location)

func _ready():
	DoomsdaySurfer(Global.unit_data.doomsday_surfer)
	KaijuPlant(Global.unit_data.kaiju_plant)
	PowerCollector(Global.unit_data.power_collector)
	Survivors(Global.unit_data.survivors)
	interface.set_breakpoint_time(Global.game_time)
	interface.connect("energy_bar_charged", self, "_on_energy_bar_charged")
	interface.connect("survivors_starved", self, "_on_survivors_starved")
	place_kaiju_enemy_marker()

func DoomsdaySurfer(data):
	var unit = Global.DoomsdaySurfer.instance()
	unit.connect("surfer_moved", self, "_on_surfer_moved")
	unit.connect("timeout", self, "_on_surfer_timeout")
	var loc = grid.get_location_at(Vector2(1, 0))
	_on_surfer_moved(null, loc.quadrant)
	unit.initialize(loc)
	units.add_child(unit)

func KaijuPlant(data):
	var unit = Global.KaijuPlant.instance()
	unit.connect("killed_enemy_kaiju", self, "_on_enemy_kaiju_killed")
	unit.initialize(grid.get_location_at(Vector2(3, 0)))
	units.add_child(unit)

func PowerCollector(data):
	var unit = Global.PowerCollector.instance()
	unit.connect("power_cell_collected", self, "_on_power_cell_collected")
	unit.initialize(grid.get_location_at(Vector2(1, 2)))
	units.add_child(unit)

func Survivors(data):
	var unit = Global.Survivors.instance()
	unit.connect("food_collected", self, "_on_food_collected")
	unit.initialize(grid.get_location_at(Vector2(3, 2)))
	units.add_child(unit)

func set_active_unit(unit):
	if active_unit:
		active_unit.unselect()
	active_unit = unit
	if active_unit:
		active_unit.select()

func _on_enemy_kaiju_killed(loc):
	loc.enemy.queue_free()
	loc.enemy = null
	enemy_kaiju = null
	$Timers/EnemyKaijuTimer.stop()
	$Timers/EnemyKaijuDeathTimer.start()
	enemy_kaiju_marker.queue_free()
	enemy_kaiju_marker = null

func _on_surfer_moved(last_quadrant, current_quadrant):
	if stopped_timer:
		stopped_timer.start()
	stopped_timer = _get_quadrant_timer(current_quadrant)
	stopped_timer.stop()
	if last_quadrant:
		quadrants[last_quadrant].start_marker()
	quadrants[current_quadrant].reset_marker()

func _on_surfer_timeout(quadrant):
	stopped_timer.start()
	quadrants[quadrant].start_marker()

func _on_power_cell_collected():
	interface.increase_power_level()

func _on_food_collected():
	interface.decrease_hunger()

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
	power_cells.add_child(power_cell)

func _on_Food_timeout():
	var free_locations = grid.get_free_locations()
	if free_locations.size() == 0:
		return
	randomize()
	var loc = free_locations[randi() % free_locations.size()]
	var chicken = Global.Food.instance()
	chicken.position = loc.position
	loc.food = chicken
	food.add_child(chicken)

func _on_EnemyKaijuTimer_timeout():
	if enemy_kaiju:
		enemy_kaiju.move_to(enemy_kaiju_marker.location)
	else:
		enemy_kaiju = Global.EnemyKaiju.instance()
		enemy_kaiju.connect("killed_unit", self, "_on_enemy_kaiju_killed_unit")
		enemy_kaiju.initialize(enemy_kaiju_marker.location)
		add_child(enemy_kaiju)
	place_kaiju_enemy_marker()

func _on_EnemyKaijuDeathTimer_timeout():
	$Timers/EnemyKaijuTimer.start()
	place_kaiju_enemy_marker()

func _on_enemy_kaiju_killed_unit(loc):
	_kill_unit(loc)

func _on_survivors_starved():
	_game_over()
func _on_energy_bar_charged():
	var quadrant_dict = grid.get_quadrant_with_highest_danger_level()
	quadrants[quadrant_dict.id].update_marker_position(quadrant_dict.locations[0].position)
	for loc in quadrant_dict.locations:
		if loc.disaster:
			loc.disaster.queue_free()
			loc.disaster = null
	quadrant_dict.level = 0

func place_kaiju_enemy_marker():
	var free_locations = grid.get_free_locations_enemy()
	if free_locations.size() == 0:
		return
	var next_loc = free_locations[randi() % free_locations.size()]
	if not enemy_kaiju_marker:
		var loc = free_locations[randi() % free_locations.size()]
		enemy_kaiju_marker = Global.Marker.instance()
		enemy_kaiju_marker.position = loc.position
		enemy_kaiju_marker.location = loc
		enemy_kaiju_marker.next_location = next_loc
		add_child(enemy_kaiju_marker)
	else:
		var loc = enemy_kaiju_marker.next_location
		enemy_kaiju_marker.position = loc.position
		enemy_kaiju_marker.location = loc
		enemy_kaiju_marker.next_location = next_loc
	enemy_kaiju_marker.animate()

func _get_quadrant_timer(quadrant):
	return $Timers.get_child(quadrant)

func _kill_unit(loc):
	if loc.unit:
		if loc.unit.name == "DoomsdaySurfer" and stopped_timer:
			stopped_timer.start()
		if loc.unit.name == "Survivors":
			_game_over()
		loc.unit.queue_free()
		loc.unit = null
		set_active_unit(null)

func _check_game_over():
	if _all_quadrants_destroyed():
		_game_over()

func _all_quadrants_destroyed():
	for quadrant in grid.quadrants:
		if quadrant.level < 4:
			return false
	return true

func _game_over():
	get_tree().change_scene(Global.GameOver)

func _on_BreakPoint_timeout():
	get_tree().change_scene(Global.Ending)