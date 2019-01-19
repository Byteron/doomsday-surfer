extends Node2D

enum QUADRANT { TSUNAMI = 0, LAVA = 1, TORNADO = 2, EARTHQUAKE = 3}

var active_unit = null
var stopped_timer = null

var enemy_kaiju = null
var marker = null

onready var grid = $Grid
onready var units = $Units
onready var power_cells = $PowerCells

onready var quadrants = [ $Q1, $Q2, $Q3, $Q4 ]

onready var tsunami_timer = $Timers/Tsunami
onready var lava_timer = $Timers/Lava
onready var earthquake_timer = $Timers/Earthquake
onready var tornado_timer = $Timers/Tornado

onready var power_cell_timer = $Timers/PowerCell

onready var interface = $Interface

func _unhandled_input(event):
	if Input.is_action_just_pressed("click_left"):
		var mouse_cell = grid.world_to_map(get_local_mouse_position())
		var mouse_location = grid.get_location_at(mouse_cell)
		if active_unit:
			if not mouse_location.unit and not mouse_location.disaster:
				active_unit.move_to(mouse_location)
				set_active_unit(null)
		elif not active_unit: 
			var unit = grid.get_unit_at(mouse_cell)
			set_active_unit(unit)
		print(mouse_location)
	
	if Input.is_action_just_pressed("click_right"):
		set_active_unit(null)

func _ready():
	_on_DoomsdaySurfer_pressed(Global.unit_data.doomsday_surfer)
	_on_KaijuPlant_pressed(Global.unit_data.kaiju_plant)
	_on_PowerCollector_pressed(Global.unit_data.power_collector)
	_on_Survivors_pressed(Global.unit_data.survivors)
	
	interface.connect("energy_bar_charged", self, "_on_energy_bar_charged")
	place_marker()

func _process(delta):
	interface.update_tsunami_time(tsunami_timer.time_left)
	interface.update_lava_time(lava_timer.time_left)
	interface.update_earthquake_time(earthquake_timer.time_left)
	interface.update_tornado_time(tornado_timer.time_left)
	
func set_active_unit(unit):
	active_unit = unit

func _on_DoomsdaySurfer_pressed(data):
	var unit = Global.DoomsdaySurfer.instance()
	unit.connect("surfer_moved", self, "_on_surfer_moved")
	unit.connect("timeout", self, "_on_surfer_timeout")
	var loc = grid.get_location_at(Vector2(1, 0))
	_on_surfer_moved(loc.quadrant)
	unit.initialize(loc)
	units.add_child(unit)

func _on_KaijuPlant_pressed(data):
	var unit = Global.KaijuPlant.instance()
	unit.connect("killed_enemy_kaiju", self, "_on_enemy_kaiju_killed")
	unit.initialize(grid.get_location_at(Vector2(3, 0)))
	units.add_child(unit)

func _on_PowerCollector_pressed(data):
	var unit = Global.PowerCollector.instance()
	unit.connect("power_cell_collected", self, "_on_power_cell_collected")
	unit.initialize(grid.get_location_at(Vector2(1, 2)))
	units.add_child(unit)

func _on_Survivors_pressed(data):
	var unit = Global.Survivors.instance()
	unit.initialize(grid.get_location_at(Vector2(3, 2)))
	units.add_child(unit)

func _on_enemy_kaiju_killed(loc):
	loc.enemy.queue_free()
	loc.enemy = null
	enemy_kaiju = null
	$Timers/EnemyKaijuTimer.stop()
	$Timers/EnemyKaijuDeathTimer.start()
	marker.queue_free()
	marker = null

func _on_surfer_moved(quadrant):
	if stopped_timer:
		stopped_timer.start()
	stopped_timer = _get_quadrant_timer(quadrant)
	stopped_timer.stop()

func _on_surfer_timeout():
	if stopped_timer:
		stopped_timer.start()
		stopped_timer = null

func _on_power_cell_collected():
	interface.increase_power_level()

func _on_Tsunami_timeout():
	if grid.get_quadrant_level(TSUNAMI) < 4:
		grid.increase_quadrant_level(TSUNAMI)
		var loc = grid.get_quadrant_location(TSUNAMI, grid.get_quadrant_level(TSUNAMI) - 1)
		# grid.set_cellv(loc.cell, 0)
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
		#grid.set_cellv(loc.cell, 2)
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
		# grid.set_cellv(loc.cell, 6)
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
		# grid.set_cellv(loc.cell, 4)
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

func _on_EnemyKaijuTimer_timeout():
	if enemy_kaiju:
		enemy_kaiju.move_to(marker.location)
	else:
		enemy_kaiju = Global.EnemyKaiju.instance()
		enemy_kaiju.connect("killed_unit", self, "_on_enemy_kaiju_killed_unit")
		enemy_kaiju.initialize(marker.location)
		add_child(enemy_kaiju)
	place_marker()

func _on_EnemyKaijuDeathTimer_timeout():
	$Timers/EnemyKaijuTimer.start()
	place_marker()

func _on_enemy_kaiju_killed_unit(loc):
	_kill_unit(loc)

func _on_energy_bar_charged():
	var quadrant = grid.get_quadrant_with_highest_danger_level()
	for loc in quadrant.locations:
		if loc.disaster:
			loc.disaster.queue_free()
			loc.disaster = null
	quadrant.level = 0

func place_marker():
	var free_locations = grid.get_free_locations_enemy()
	if free_locations.size() == 0:
		return
	var next_loc = free_locations[randi() % free_locations.size()]
	if not marker:
		var loc = free_locations[randi() % free_locations.size()]
		marker = Global.Marker.instance()
		marker.position = loc.position
		marker.location = loc
		marker.next_location = next_loc
		add_child(marker)
	else:
		var loc = marker.next_location
		marker.position = loc.position
		marker.location = loc
		marker.next_location = next_loc
	marker.animate()

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
