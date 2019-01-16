extends Node2D

var active_unit = null

onready var grid = $Grid
onready var units = $Units

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
	
	$Interface/UnitButtons/DoomsdaySurfer.connect("pressed", self, "_on_DoomsdaySurfer_pressed", [Global.unit_data.doomsday_surfer])
	$Interface/UnitButtons/KaijuPlant.connect("pressed", self, "_on_KaijuPlant_pressed", [Global.unit_data.kaiju_plant])
	$Interface/UnitButtons/PowerCollector.connect("pressed", self, "_on_PowerCollector_pressed", [Global.unit_data.power_collector])
	$Interface/UnitButtons/Survivors.connect("pressed", self, "_on_Survivors_pressed", [Global.unit_data.survivors])

func set_active_unit(unit):
	active_unit = unit

func _on_DoomsdaySurfer_pressed(data):
	var unit = Global.Unit.instance()
	unit.initialize(data, grid.get_location_at(Vector2(1, 0)))
	units.add_child(unit)
	$Interface/UnitButtons/DoomsdaySurfer.hide()
func _on_KaijuPlant_pressed(data):
	var unit = Global.Unit.instance()
	unit.initialize(data, grid.get_location_at(Vector2(3, 0)))
	units.add_child(unit)
	$Interface/UnitButtons/KaijuPlant.hide()

func _on_PowerCollector_pressed(data):
	var unit = Global.Unit.instance()
	unit.initialize(data, grid.get_location_at(Vector2(1, 3)))
	units.add_child(unit)
	$Interface/UnitButtons/PowerCollector.hide()

func _on_Survivors_pressed(data):
	var unit = Global.Unit.instance()
	unit.initialize(data, grid.get_location_at(Vector2(3, 3)))
	units.add_child(unit)
	$Interface/UnitButtons/Survivors.hide()

