extends Node

# general
var game_time = 0

# disasters
var tsunami_time = 0
var lava_time = 0
var earthquake_time = 0
var tornado_time = 0

# power collector
var power_cell_time = 0
var power_cell_amount = 0

# survivors
var food_time = 0
var food_fill = 0
var food_amount = 0
var food_tick = 0

# plant kaiju
var enemy_move_time = 0
var enemy_spawn_time = 0

# doomsday surfer
var surf_time = 0

func easy():
	game_time = 60
	tsunami_time = 15
	lava_time = 18
	earthquake_time = 16
	tornado_time = 14
	power_cell_time = 4
	power_cell_amount = 4
	food_time = 6
	food_fill = 2
	food_tick = 4
	food_amount = 8
	enemy_move_time = 8
	enemy_spawn_time = 12
	surf_time = 12
	
func medium():
	game_time = 60
	tsunami_time = 11
	lava_time = 15
	earthquake_time = 15
	tornado_time = 13
	power_cell_time = 3
	power_cell_amount = 4
	food_time = 4
	food_fill = 2
	food_tick = 3
	food_amount = 8
	enemy_move_time = 5
	enemy_spawn_time = 10
	surf_time = 10
	
func hard():
	game_time = 90
	tsunami_time = 10
	lava_time = 14
	earthquake_time = 13
	tornado_time = 12
	power_cell_time = 3
	power_cell_amount = 5
	food_time = 2
	food_fill = 1
	food_tick = 3
	food_amount = 6
	enemy_move_time = 3
	enemy_spawn_time = 8
	surf_time = 8
