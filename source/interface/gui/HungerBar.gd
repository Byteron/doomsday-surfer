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
	if not _is_close_to_starve():
		$AnimationPlayer.stop(true)
		modulate = Color("ffffff")

func _on_Timer_timeout():
	if visible:
		value += 1
		
		if _is_close_to_starve():
			$AudioStreamPlayer.play()
			$AnimationPlayer.play("warn")
		
		if value >= max_value:
			emit_signal("starved")

func _is_close_to_starve():
	return value * 2 > max_value
	
