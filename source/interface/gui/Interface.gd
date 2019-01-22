extends CanvasLayer

signal energy_bar_charged()
signal survivors_starved()
signal tile_changed(cell)

onready var energy_bar = $Quadrant4/EnergyBar
onready var hunger_bar = $Quadrant3/HungerBar
onready var breakpoint_bar = $BorderRight/BreakPoint

onready var cursor = $Cursor

func _unhandled_input(event):
	var game = get_parent()
	var mouse_position = game.grid.world_to_world(game.get_global_mouse_position())
	if mouse_position != cursor.rect_position:
		emit_signal("tile_changed", mouse_position)

func _ready():
	connect("tile_changed", self, "_on_tile_changed")
	energy_bar.connect("charged", self, "_on_EnergyBar_charged")
	hunger_bar.connect("starved", self, "_on_HungerBar_starved")

func set_breakpoint_time(time):
	breakpoint_bar.set_time(time)

func set_hunger_tick(time):
	hunger_bar.set_food_time(time)

func set_hunger_fill(fill):
	hunger_bar.set_food_fill(fill)

func set_hunger_amount(amount):
	hunger_bar.set_food_amount(amount)

func set_power_cell_amount(amount):
	energy_bar.max_value = amount

func decrease_hunger():
	hunger_bar.decrease()

func increase_power_level():
	energy_bar.increase()

func _on_EnergyBar_charged():
	emit_signal("energy_bar_charged")

func _on_HungerBar_starved():
	emit_signal("survivors_starved")

func _on_tile_changed(position):
	cursor.rect_position = position