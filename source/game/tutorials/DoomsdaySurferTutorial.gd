extends "res://source/game/tutorials/Tutorial.gd"

var stopped_timer = null

var doomsday_surfer = null

func _ready():
	._ready()
	interface.hide_hunger_bar()
	interface.hide_energy_bar()
	interface.hide_breakpoint_bar()
	animate_markers()
	DoomsdaySurfer()
	doomsday_surfer.set_surfing_time(4)
	get_tree().call_group("Timer", "start")
	popup_text.popup_centered("Doomsday Surfer", "The Doomsdaysurfer prevents disasters from spawning in his current area.")

func DoomsdaySurfer():
	var unit = Global.DoomsdaySurfer.instance()
	doomsday_surfer = unit
	unit.connect("surfer_moved", self, "_on_surfer_moved")
	unit.connect("timeout", self, "_on_surfer_timeout")
	var loc = grid.get_location_at(Vector2(1, 0))
	unit.initialize(loc)
	units.add_child(unit)

func animate_markers():
	for quadrant in quadrants:
		quadrant.start_marker()

func _on_surfer_moved(last_quadrant, current_quadrant):
	if stopped_timer:
		stopped_timer.start()
	stopped_timer = _get_quadrant_timer(current_quadrant)
	stopped_timer.stop()
	if last_quadrant:
		quadrants[last_quadrant].start_marker()
	quadrants[current_quadrant].reset_marker()
	print(current_quadrant, " ", quadrants[current_quadrant].name)
	popup_text.popup_centered("Doomsday Surfer", "You moved the Doomsday Surfer. Hurray! If he comes from another area, he will prevent disasters from spawning now!")

func _on_surfer_timeout(quadrant):
	stopped_timer.start()
	quadrants[quadrant].start_marker()
	popup_text.popup_centered("Doomstday Surfer", "After some time the Doomsdaysurfer becomes inactive! Move the Doomsday Surfer to prevent disasters in another area!")