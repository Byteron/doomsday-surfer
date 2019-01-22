extends "res://source/game/tutorials/Tutorial.gd"

var survivors

func _ready():
	._ready()
	interface.hide_energy_bar()
	interface.hide_breakpoint_bar()
	animate_markers()
	Survivors()
	get_tree().call_group("Timer", "start")
	interface.connect("survivors_starved", self, "_on_survivors_starved")
	popup_text.popup_centered("Survivors", "The Survivors have just one job: Don't die! Meaning, you have to keep them save from disasters and enemies, as well was collecting food, so they don't starve.")

func Survivors():
	var unit = Global.Survivors.instance()
	survivors = unit
	unit.connect("food_collected", self, "_on_food_collected")
	unit.initialize(grid.get_location_at(Vector2(3, 2)))
	units.add_child(unit)

func _on_Food_timeout():
	var free_locations = grid.get_free_locations()
	if free_locations.size() == 0:
		return
	randomize()
	var loc = free_locations[randi() % free_locations.size()]
	var chicken = Global.Food.instance()
	chicken.position = loc.position
	loc.food = chicken
	items.add_child(chicken)

func _on_food_collected():
	interface.decrease_hunger()
	popup_text.popup_centered("Survivors", "You collected food! Your hunger bar decreases a bit. It must not fill completely, otherwise your survivors starve!")
	
func _on_survivors_starved():
	emit_signal("game_over", "Survivors starved")