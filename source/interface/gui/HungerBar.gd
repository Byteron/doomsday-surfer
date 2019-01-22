extends TextureProgress

signal starved

var food_fill = 2

onready var timer = $Timer

func set_food_time(time):
	timer.wait_time = time

func set_food_fill(fill):
	food_fill = fill

func set_food_amount(amount):
	max_value = amount

func decrease():
	value = clamp(value - food_fill, 0, max_value)

func _on_Timer_timeout():
	value += 1
	if value >= max_value:
		emit_signal("starved")
