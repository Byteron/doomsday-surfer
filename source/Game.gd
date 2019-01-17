extends Node2D

var active_unit = null

onready var grid = $Grid
onready var units = $Units

onready var tsunami_timer = $Timers/Tsunami
onready var lava_timer = $Timers/Lava
onready var earthquake_timer = $Timers/Earthquake
onready var tornado_timer = $Timers/Tornado

onready var interface = $Interface

func _unhandled_input(event):
	if Input.is_action_just_pressed("click_left"):
		var mouse_cell = grid.world_to_map(get_global_mouse_position())
		var mouse_location = grid.get_location_at(mouse_cell)
		if active_unit:
			if not mouse_location.unit:
				active_unit.move_to(mouse_location)
				set_active_unit(null)
		elif not active_unit: 
			var unit = grid.get_unit_at(mouse_cell)
			set_active_unit(unit)
		print(mouse_location)
	
	if Input.is_action_just_pressed("click_right"):
		set_active_unit(null)

func _ready():
	$Interface/Quadrant1/DangerLevelBar.level = 1
	$Interface/Quadrant2/DangerLevelBar.level = 2
	$Interface/Quadrant3/DangerLevelBar.level = 3
	$Interface/Quadrant4/DangerLevelBar.level = 4
	
	$Interface/BorderRight/DoomsdaySurfer.connect("pressed", self, "_on_DoomsdaySurfer_pressed", [Global.unit_data.doomsday_surfer])
	$Interface/BorderRight/KaijuPlant.connect("pressed", self, "_on_KaijuPlant_pressed", [Global.unit_data.kaiju_plant])
	$Interface/BorderRight/PowerCollector.connect("pressed", self, "_on_PowerCollector_pressed", [Global.unit_data.power_collector])
	$Interface/BorderRight/Survivors.connect("pressed", self, "_on_Survivors_pressed", [Global.unit_data.survivors])

func _process(delta):
	interface.update_tsunami_time(tsunami_timer.time_left)
	interface.update_lava_time(lava_timer.time_left)
	interface.update_earthquake_time(earthquake_timer.time_left)
	interface.update_tornado_time(tornado_timer.time_left)
	
func set_active_unit(unit):
	active_unit = unit

func _on_DoomsdaySurfer_pressed(data):
	var unit = Global.Unit.instance()
	unit.initialize(data, grid.get_location_at(Vector2(1, 0)))
	units.add_child(unit)
	$Interface/BorderRight/DoomsdaySurfer.hide()
func _on_KaijuPlant_pressed(data):
	var unit = Global.Unit.instance()
	unit.initialize(data, grid.get_location_at(Vector2(3, 0)))
	units.add_child(unit)
	$Interface/BorderRight/KaijuPlant.hide()

func _on_PowerCollector_pressed(data):
	var unit = Global.Unit.instance()
	unit.initialize(data, grid.get_location_at(Vector2(1, 2)))
	units.add_child(unit)
	$Interface/BorderRight/PowerCollector.hide()

func _on_Survivors_pressed(data):
	var unit = Global.Unit.instance()
	unit.initialize(data, grid.get_location_at(Vector2(3, 2)))
	units.add_child(unit)
	$Interface/BorderRight/Survivors.hide()

func _on_Tsunami_timeout():
	if Global.quadrants.tsunami.level < 4:
		Global.quadrants.tsunami.level += 1
		grid.set_cellv(Global.quadrants.tsunami.cells[Global.quadrants.tsunami.level - 1], 0)
	check_game_over()


func _on_Lava_timeout():
	if Global.quadrants.lava.level < 4:
		Global.quadrants.lava.level += 1
		grid.set_cellv(Global.quadrants.lava.cells[Global.quadrants.lava.level - 1], 2)
	check_game_over()


func _on_Earthquake_timeout():
	if Global.quadrants.earthquake.level < 4:
		Global.quadrants.earthquake.level += 1
		grid.set_cellv(Global.quadrants.earthquake.cells[Global.quadrants.earthquake.level - 1], 6)
	check_game_over()


func _on_Tornado_timeout():
	if Global.quadrants.tornado.level < 4:
		Global.quadrants.tornado.level += 1
		grid.set_cellv(Global.quadrants.tornado.cells[Global.quadrants.tornado.level - 1], 4)
	check_game_over()

func check_game_over():
	if all_quadrants_destroyed():
		game_over()

func all_quadrants_destroyed():
	for quadrant in Global.quadrants.values():
		if quadrant.level < 4:
			return false
	return true

func game_over():
	get_tree().change_scene(Global.MainMenu)