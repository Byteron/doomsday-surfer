extends Node

# scenes
var MainMenu = "res://source/interface/menu/MainMenu.tscn"
var Game = "res://source/Game.tscn"

# classes
var Unit = load("res://source/units/Unit.tscn")
var Disaster = load("res://source/Disaster.tscn")
var PowerCell = load("res://source/items/PowerCell.tscn")

# textures
var tsunami_tex = load("res://graphics/terrain/tsunami.png")
var lava_tex = load("res://graphics/terrain/lava.png")
var earthquake_tex = load("res://graphics/terrain/earthquake.png")
var tornado_tex = load("res://graphics/terrain/tornado.png")

# unit data
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