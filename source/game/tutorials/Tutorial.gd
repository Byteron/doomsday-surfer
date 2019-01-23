extends Node2D

signal game_over(cause)

enum QUADRANT { TSUNAMI = 0, LAVA = 1, EARTHQUAKE = 2, TORNADO = 3}

var active_unit = null

onready var quadrants = [ $Q1, $Q2, $Q3, $Q4 ]

onready var popup_text = $Interface/PopupText

onready var tsunami_marker = $Q1/Marker
onready var lava_marker = $Q2/Marker
onready var earthquake_marker = $Q3/Marker
onready var tornado_marker = $Q4/Marker

onready var items = $Items
onready var units = $Units

onready var grid = $Grid
onready var interface = $Interface

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Transition.change_scene(Global.Controls)

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

func animate_markers():
	for quadrant in quadrants:
		quadrant.start_marker()

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

#
# P R I V A T E   F U N C
#

func _get_quadrant_timer(quadrant):
	return $Timers.get_child(quadrant)

func _kill_unit(loc):
	if loc.unit:
		$DieSound.play()
		if loc.unit.name == "DoomsdaySurfer":
			emit_signal("game_over", "Doomsday Surfer died")
		if loc.unit.name == "Survivors":
			emit_signal("game_over", "Survivors died")
		if loc.unit.name == "PowerCollector":
			emit_signal("game_over", "PowerCollector died")
		if loc.unit.name == "KaijuPlant":
			emit_signal("game_over", "Plant Kaiju died")
		loc.unit.queue_free()
		loc.unit = null
		set_active_unit(null)

func _check_game_over():
	if _all_quadrants_destroyed():
		emit_signal("game_over", "All Quadrants have been destroyed")

func _all_quadrants_destroyed():
	for quadrant in grid.quadrants:
		if quadrant.level < 4:
			return false
	return true

func _game_over():
	Transition.change_scene(Global.Controls)
