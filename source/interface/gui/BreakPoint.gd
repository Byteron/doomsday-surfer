extends ProgressBar

onready var timer = $Timer

func set_time(time):
	timer.wait_time = time
	max_value = time
	value = 0
	timer.start()

func _process(delta):
	print(timer.time_left, "/", timer.wait_time)
	value = timer.wait_time - timer.time_left