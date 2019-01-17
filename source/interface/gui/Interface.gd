extends CanvasLayer

onready var tsunami_time = $BorderLeft/TimerLabels/Tsunami
onready var earthquake_time = $BorderLeft/TimerLabels/Earthquake
onready var tornado_time = $BorderLeft/TimerLabels/Tornado
onready var lava_time = $BorderLeft/TimerLabels/Lava

func _ready():
	pass

func update_tsunami_time(time):
	tsunami_time.text = "Tsunami: " + str(time).pad_decimals(0)

func update_lava_time(time):
	lava_time.text = "Lava: " + str(time).pad_decimals(0)

func update_earthquake_time(time):
	earthquake_time.text = "Earthquake: " + str(time).pad_decimals(0)

func update_tornado_time(time):
	tornado_time.text = "Tornado: " + str(time).pad_decimals(0)