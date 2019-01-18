extends ProgressBar

var timer = Timer.new()

func _ready():
	timer.set_wait_time(1)
	timer.set_timer_process_mode(Timer.TIMER_PROCESS_IDLE)
	timer.set_one_shot(false)
	timer.connect("timeout", self, "update")
	
	add_child(timer)
	timer.start()

func update():
	if get_child(0).wait_time !=0:
		self.value += 1	