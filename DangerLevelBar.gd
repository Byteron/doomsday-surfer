extends Control

const ACTIVE = Color("FFFFFF")
const INACTIVE = Color("111111")

var level = 3 setget _set_level, _get_level

func _ready():
	update_bar()

func update_bar():
	_set_all_inactive()
	for i in range(level):
		_set_active(i)

func _set_all_inactive():
	for i in range(4):
		_set_inactive(i)

func _set_inactive(level):
	get_child(level).modulate = INACTIVE

func _set_active(level):
	get_child(level).modulate = ACTIVE

func _set_level(value):
	if value < 5 and value > 0:
		level = value
		_update_bar()

func _get_level():
	return level
