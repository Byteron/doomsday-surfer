extends TextureProgress

signal charged

func increase():
	value += 1
	if value == max_value:
		value = 0
		emit_signal("charged")