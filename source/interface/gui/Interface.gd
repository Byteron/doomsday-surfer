extends CanvasLayer

signal energy_bar_charged
signal survivors_starved

onready var energy_bar = $Quadrant4/EnergyBar
onready var hunger_bar = $Quadrant3/HungerBar
onready var breakpoint_bar = $BorderRight/BreakPoint

func _ready():
	energy_bar.connect("charged", self, "_on_EnergyBar_charged")
	hunger_bar.connect("starved", self, "_on_HungerBar_starved")

func set_breakpoint_time(time):
	breakpoint_bar.set_time(time)

func decrease_hunger():
	hunger_bar.decrease()

func increase_power_level():
	energy_bar.increase()

func _on_EnergyBar_charged():
	emit_signal("energy_bar_charged")

func _on_HungerBar_starved():
	emit_signal("survivors_starved")