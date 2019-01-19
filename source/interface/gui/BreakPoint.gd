extends ProgressBar

onready var timer = $Timer

func set_time(time):
	timer.wait_time = time
	max_value = time
	value = 0
	timer.start()

func _process(delta):
	value = timer.wait_time - timer.time_left
