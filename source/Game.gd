extends Node2D

var active_unit = null

onready var grid = $Grid

func _unhandled_input(event):
	if Input.is_action_just_pressed("click_left"):
		var mouse_cell = grid.world_to_map(get_global_mouse_position())
		if active_unit:
			active_unit.move_to(mouse_cell)
		else: 
			var unit = grid.get_unit_at(mouse_cell)
			print(grid.get_location_at(mouse_cell))
			set_active_unit(unit)
	
	if Input.is_action_just_pressed("click_right"):
		set_active_unit(null)

func _ready():
	$Interface/Quadrant1/DangerLevelBar.level = 1
	$Interface/Quadrant2/DangerLevelBar.level = 2
	$Interface/Quadrant3/DangerLevelBar.level = 3
	$Interface/Quadrant4/DangerLevelBar.level = 4
	
	$Interface/UnitButtons/DoomsdaySurfer.connect("pressed", self, "_on_DoomsdaySurfer_pressed", ["DoomsdaySurfer"])
	$Interface/UnitButtons/KaijuPlant.connect("pressed", self, "_on_KaijuPlant_pressed", ["KaijuPlant"])
	$Interface/UnitButtons/PowerCollector.connect("pressed", self, "_on_PowerCollector_pressed", ["PowerCollector"])
	$Interface/UnitButtons/Survivors.connect("pressed", self, "_on_Survivors_pressed", ["Survivors"])

func set_active_unit(unit):
	active_unit = unit

func _on_DoomsdaySurfer_pressed(unit):
	print(unit)

func _on_KaijuPlant_pressed(unit):
	print(unit)

func _on_PowerCollector_pressed(unit):
	print(unit)

func _on_Survivors_pressed(unit):
	print(unit)
