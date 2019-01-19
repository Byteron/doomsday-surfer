extends TextureProgress

signal starved

func decrease():
	value = clamp(value - 2, 0, max_value)

func _on_Timer_timeout():
	value += 1
	if value >= max_value:
		emit_signal("starved")
