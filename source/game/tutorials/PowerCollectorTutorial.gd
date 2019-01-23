extends "res://source/game/tutorials/Tutorial.gd"

var power_collector

var collected = false
var charged = false

func _ready():
	._ready()
	interface.hide_hunger_bar()
	interface.hide_breakpoint_bar()
	animate_markers()
	PowerCollector()
	get_tree().call_group("Timer", "start")
	interface.connect("energy_bar_charged", self, "_on_energy_bar_charged")
	popup_text.popup_centered("Power Collector", "The Power Collector gathers power cells to activate the CCC - The Clima Control Center.")

func PowerCollector():
	var unit = Global.PowerCollector.instance()
	power_collector = unit
	unit.connect("power_cell_collected", self, "_on_power_cell_collected")
	unit.initialize(grid.get_location_at(Vector2(1, 2)))
	units.add_child(unit)

func _on_PowerCell_timeout():
	var free_locations = grid.get_free_locations()
	if free_locations.size() == 0:
		return
	randomize()
	var loc = free_locations[randi() % free_locations.size()]
	var power_cell = Global.PowerCell.instance()
	power_cell.position = loc.position
	loc.power_cell = power_cell
	items.add_child(power_cell)

func _on_energy_bar_charged():
	if not charged:
		charged = true
		popup_text.popup_centered("Power Collector", "The Energy Bar is full! Now a quadrant will be resetted!")
	var quadrant_dict = grid.get_quadrant_with_highest_danger_level()
	var quadrant = quadrants[quadrant_dict.id]
	quadrant.update_marker_position(quadrant_dict.locations[0].position)
	_spawn_thunder(quadrant_dict.locations[3].position - Vector2(64, 64))
	quadrant.reset_marker()
	quadrant.start_marker()
	var quadrant_timer = _get_quadrant_timer(quadrant_dict.id)
	quadrant_timer.stop()
	quadrant_timer.start()
	for loc in quadrant_dict.locations:
		if loc.disaster:
			loc.disaster.queue_free()
			loc.disaster = null
	quadrant_dict.level = 0

var thunder = null
func _spawn_thunder(position):
	thunder = Global.Thunder.instance()
	thunder.position = position
	add_child(thunder)
	thunder.connect("animation_finished", self, "_on_thunder_animation_finished")
	thunder.play("flash")

func _on_thunder_animation_finished():
	thunder.queue_free()
	thunder = null

func _on_power_cell_collected():
	if not collected:
		collected = true
		popup_text.popup_centered("Power Collector", "You collected a power cell! Your energy bar filled up a bit. If it is full, the disasters of the area with the highest danger level (amount of disasters) will be removed!")
	interface.increase_power_level()