extends Node

var MainMenu = "res://source/interface/menu/MainMenu.tscn"
var Game = "res://source/Game.tscn"

var Unit = load("res://source/units/Unit.tscn")

var unit_data = {
	doomsday_surfer = {
		name = "DoomsdaySurfer",
		tex = load("res://graphics/units/doomsday_surfer.png")
	},
	kaiju_plant = {
		name = "KaijuPlant",
		tex = load("res://graphics/units/kaiju_plant.png")
	},
	power_collector = {
		name = "PowerCollector",
		tex = load("res://graphics/units/power_collector.png")
	},
	survivors = {
		name = "Survivors",
		tex = load("res://graphics/units/survivors.png")
	}
}

var quadrants = {
	tsunami = {
		level = 0, 
		cells = [
			Vector2(1, 1),
			Vector2(0, 1),
			Vector2(1, 0),
			Vector2(0, 0)
		]
	},
	lava = {
		level = 0,
		cells = [
			Vector2(3, 1),
			Vector2(2, 1),
			Vector2(3, 0),
			Vector2(2, 0)
		]
	},
	tornado = {
		level = 0,
		cells = [
			Vector2(1, 3),
			Vector2(0, 3),
			Vector2(1, 2),
			Vector2(0, 2)
		]
	},
	earthquake = {
		level = 0,
		cells = [
			Vector2(3, 3),
			Vector2(2, 3),
			Vector2(3, 2),
			Vector2(2, 2)
		]
	}
}