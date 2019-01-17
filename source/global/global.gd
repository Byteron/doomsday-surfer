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