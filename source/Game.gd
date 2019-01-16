extends Node2D

var active_unit = null

onready var grid = $Grid

func _unhandled_input(event):
	if Input.is_action_just_pressed("click_left"):
		var mouse_cell = grid.world_to_map(get_global_mouse_position())
		if not active_unit:
			var unit = grid.get_unit_at(mouse_cell)
			set_active_unit(unit)
		elif active_unit: 
			active_unit.move_to(mouse_cell)

func _ready():
	$Interface/Quadrant1/DangerLevelBar.level = 1
	$Interface/Quadrant2/DangerLevelBar.level = 2
	$Interface/Quadrant3/DangerLevelBar.level = 3
	$Interface/Quadrant4/DangerLevelBar.level = 4

func set_active_unit(unit):
	active_unit = unit
	