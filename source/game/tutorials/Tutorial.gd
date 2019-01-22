extends Node2D

signal game_over(cause)

enum QUADRANT { TSUNAMI = 0, LAVA = 1, EARTHQUAKE = 2, TORNADO = 3}

var active_unit = null

onready var quadrants = [ $Q1, $Q2, $Q3, $Q4 ]

onready var items = $Items
onready var units = $Units

onready var grid = $Grid
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

func _ready():
	connect("game_over", self, "_on_game_over")

func set_active_unit(unit):
	if active_unit:
		active_unit.unselect()
	active_unit = unit
	if active_unit:
		active_unit.select()

#
# S I G N A L   F U N C
#

func _on_game_over(cause):
	Global.defeat_reason = cause
	_game_over()

#
# P R I V A T E   F U N C
#

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
