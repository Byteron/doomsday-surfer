extends Node2D

signal game_over(cause)

enum QUADRANT { TSUNAMI = 0, LAVA = 1, EARTHQUAKE = 2, TORNADO = 3}

var active_unit = null
var stopped_timer = null

var doomsday_surfer = null
var power_collector = null
var kaiju_plant = null
var survivors = null

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
	if event.is_action_pressed("ui_cancel"):
		Transition.change_scene(Global.MainMenu)
	
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

func _ready():
	animate_markers()
	DoomsdaySurfer()
	KaijuPlant()
	PowerCollector()
	Survivors()
	_apply_difficulty()
	connect("game_over", self, "_on_game_over")
	interface.connect("energy_bar_charged", self, "_on_energy_bar_charged")
	interface.connect("survivors_starved", self, "_on_survivors_starved")
	get_tree().call_group("Timer", "start")

func DoomsdaySurfer():
	var unit = Global.DoomsdaySurfer.instance()
	doomsday_surfer = unit
	unit.connect("surfer_moved", self, "_on_surfer_moved")
	unit.connect("timeout", self, "_on_surfer_timeout")
	var loc = grid.get_location_at(Vector2(1, 0))
	_on_surfer_moved(null, loc.quadrant)
	unit.initialize(loc)
	units.add_child(unit)

func KaijuPlant():
	var unit = Global.KaijuPlant.instance()
	kaiju_plant = unit
	unit.connect("killed_enemy_kaiju", self, "_on_enemy_kaiju_killed")
	unit.initialize(grid.get_location_at(Vector2(3, 0)))
	units.add_child(unit)

func PowerCollector():
	var unit = Global.PowerCollector.instance()
	power_collector = unit
	unit.connect("power_cell_collected", self, "_on_power_cell_collected")
	unit.initialize(grid.get_location_at(Vector2(1, 2)))
	units.add_child(unit)

func Survivors():
	var unit = Global.Survivors.instance()
	survivors = unit
	unit.connect("food_collected", self, "_on_food_collected")
	unit.initialize(grid.get_location_at(Vector2(3, 2)))
	units.add_child(unit)

func set_active_unit(unit):
	if active_unit:
		active_unit.unselect()
	active_unit = unit
	if active_unit:
		active_unit.select()

func place_kaiju_enemy_marker():
	var free_locations = grid.get_free_locations_enemy()
	if free_locations.size() == 0:
		return
	var next_loc = free_locations[randi() % free_locations.size()]
	if not enemy_kaiju_marker:
		var loc = free_locations[randi() % free_locations.size()]
		enemy_kaiju_marker = Global.Marker.instance()
		enemy_kaiju_marker.fade_time = $Timers/EnemyKaijuTimer.wait_time
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

func animate_markers():
	for quadrant in quadrants:
		quadrant.start_marker()

#
# P R I V A T E   F U N C
#

func _get_quadrant_timer(quadrant):
	return $Timers.get_child(quadrant)

func _kill_unit(loc):
	if loc.unit:
		loc.unit.connect("died", self, "_on_unit_died")
		$DieSound.play()
		loc.unit.kill()
		loc.unit = null
		set_active_unit(null)

func _on_unit_died(unit_name):
	if unit_name == "DoomsdaySurfer":
		emit_signal("game_over", "Doomsday Surfer died")
		doomsday_surfer = null
	if unit_name == "Survivors":
		emit_signal("game_over", "Survivors died")
		survivors = null
	if unit_name == "PowerCollector":
		power_collector = null
	if unit_name == "KaijuPlant":
		kaiju_plant = null

func _check_game_over():
	if _all_quadrants_destroyed():
		emit_signal("game_over", "All Quadrants have been destroyed")

func _all_quadrants_destroyed():
	for quadrant in grid.quadrants:
		if quadrant.level < 4:
			return false
	return true

func _game_over():
	Transition.change_scene(Global.GameOver)

func _apply_difficulty():
	interface.set_breakpoint_time(Difficulty.game_time)
	tsunami_timer.wait_time = Difficulty.tsunami_time
	lava_timer.wait_time = Difficulty.lava_time
	earthquake_timer.wait_time = Difficulty.earthquake_time
	tornado_timer.wait_time = Difficulty.tornado_time
	
	power_cell_timer.wait_time = Difficulty.power_cell_time
	interface.set_power_cell_amount(Difficulty.power_cell_amount)
	
	food_timer.wait_time = Difficulty.food_time
	interface.set_hunger_fill(Difficulty.food_fill)
	interface.set_hunger_tick(Difficulty.food_tick)
	interface.set_hunger_amount(Difficulty.food_amount)
	
	$Timers/EnemyKaijuTimer.wait_time = Difficulty.enemy_move_time
	$Timers/EnemyKaijuDeathTimer.wait_time = Difficulty.enemy_spawn_time
	
	doomsday_surfer.set_surfing_time(Difficulty.surf_time)
#
# S I G N A L   F U N C
#

# TIMEOUTS

func _on_BreakPoint_timeout():
	Transition.change_scene(Global.Ending)

func _on_Tsunami_timeout():
	if grid.get_quadrant_level(TSUNAMI) < 4:
		grid.increase_quadrant_level(TSUNAMI)
		var loc = grid.get_quadrant_location(TSUNAMI, grid.get_quadrant_level(TSUNAMI) - 1)
		var next_loc = grid.get_quadrant_location(TSUNAMI, grid.get_quadrant_level(TSUNAMI))
		if next_loc:
			tsunami_marker.position = next_loc.position
			tsunami_marker.animate()
		var disaster = Global.Tsunami.instance()
		disaster.position = loc.position
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
		var disaster = Global.Lava.instance()
		disaster.position = loc.position
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
		var disaster = Global.Earthquake.instance()
		disaster.position = loc.position
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
		var disaster = Global.Tornado.instance()
		disaster.position = loc.position
		loc.disaster = disaster
		quadrants[TORNADO].add_child(disaster)
		_kill_unit(loc)
	_check_game_over()

func _on_surfer_timeout(quadrant):
	stopped_timer.start()
	quadrants[quadrant].start_marker()

func _on_PowerCell_timeout():
	if power_collector:
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
	if survivors:
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

# MISC

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

func _on_game_over(cause):
	Global.defeat_reason = cause
	_game_over()

func _on_power_cell_collected():
	interface.increase_power_level()

func _on_food_collected():
	interface.decrease_hunger()

func _on_enemy_kaiju_killed_unit(loc):
	_kill_unit(loc)

func _on_survivors_starved():
	emit_signal("game_over", "Survivors starved")

var thunder = null
func _on_energy_bar_charged():
	var quadrant_dict = grid.get_quadrant_with_highest_danger_level()
	quadrants[quadrant_dict.id].update_marker_position(quadrant_dict.locations[0].position)
	_spawn_thunder(quadrant_dict.locations[3].position - Vector2(64, 64))
	for loc in quadrant_dict.locations:
		if loc.disaster:
			loc.disaster.queue_free()
			loc.disaster = null
	quadrant_dict.level = 0

func _spawn_thunder(position):
	thunder = Global.Thunder.instance()
	thunder.position = position
	add_child(thunder)
	thunder.connect("animation_finished", self, "_on_thunder_animation_finished")
	thunder.play("flash")

func _on_thunder_animation_finished():
	thunder.queue_free()
	thunder = null
	