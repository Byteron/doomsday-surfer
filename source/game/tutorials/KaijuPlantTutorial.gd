extends "res://source/game/tutorials/Tutorial.gd"

onready var enemy_move_timer = $Timers/EnemyMove
onready var enemy_spawn_timer = $Timers/EnemySpawn

var kaiju_plant = null

var enemy_kaiju = null
var enemy_kaiju_marker = null

func _ready():
	._ready()
	interface.hide_energy_bar()
	interface.hide_hunger_bar()
	interface.hide_breakpoint_bar()
	animate_markers()
	KaijuPlant()
	get_tree().call_group("Timer", "start")
	popup_text.popup_centered("Plant Kaiju", "The Plant Kaiju ist the only ally strong enough to fight against the enemy kaijus!")

func KaijuPlant():
	var unit = Global.KaijuPlant.instance()
	kaiju_plant = unit
	unit.connect("killed_enemy_kaiju", self, "_on_enemy_kaiju_killed")
	unit.initialize(grid.get_location_at(Vector2(3, 0)))
	units.add_child(unit)

func place_kaiju_enemy_marker():
	var free_locations = grid.get_free_locations_enemy()
	if free_locations.size() == 0:
		return
	var next_loc = free_locations[randi() % free_locations.size()]
	if not enemy_kaiju_marker:
		var loc = free_locations[randi() % free_locations.size()]
		enemy_kaiju_marker = Global.Marker.instance()
		enemy_kaiju_marker.fade_time = enemy_move_timer.wait_time
		enemy_kaiju_marker.position = loc.position
		enemy_kaiju_marker.location = loc
		enemy_kaiju_marker.next_location = next_loc
		add_child(enemy_kaiju_marker)
	else:
		var loc = enemy_kaiju_marker.next_location
		enemy_kaiju_marker.position = loc.position
		enemy_kaiju_marker.location = loc
		enemy_kaiju_marker.next_location = next_loc
	print("place enemy marker")
	enemy_kaiju_marker.animate()

func _on_enemy_kaiju_killed(loc):
	loc.enemy.queue_free()
	loc.enemy = null
	enemy_kaiju = null
	enemy_move_timer.stop()
	enemy_spawn_timer.start()
	enemy_kaiju_marker.queue_free()
	enemy_kaiju_marker = null
	popup_text.popup_centered("Plant Kaiju", "You killed the Enemy Kaiju!! But it is not the only one. Others will appear with time, so keep your eyes wide open!")

func _on_enemy_kaiju_killed_unit(loc):
	_kill_unit(loc)

func _on_EnemyMove_timeout():
	if enemy_kaiju:
		enemy_kaiju.move_to(enemy_kaiju_marker.location)
		popup_text.popup_centered("Plant Kaiju", "The Enemy kaiju moves around! Kill it quickly, so it does not oppose a threat to your units!")
	else:
		enemy_kaiju = Global.EnemyKaiju.instance()
		enemy_kaiju.connect("killed_unit", self, "_on_enemy_kaiju_killed_unit")
		enemy_kaiju.initialize(enemy_kaiju_marker.location)
		add_child(enemy_kaiju)
		popup_text.popup_centered("Plant Kaiju", "Beware, an Enemy Kaiju appeared! If it moves onto one of your units, your unit will die. Move the Plant Kaiju onto its position to kill it!")
	place_kaiju_enemy_marker()
	print("move timeout")

func _on_EnemySpawn_timeout():
	enemy_move_timer.start()
	print("spawn timeout")
	place_kaiju_enemy_marker()
