extends Node

# scenes
var MainMenu = "res://source/interface/menu/MainMenu.tscn"
var Game = "res://source/Game.tscn"
var Story = "res://source/Story_text.tscn"
var Options = "res://source/interface/menu/Options.tscn"
var Sold = "res://source/interface/menu/Sold.tscn"
var GameOver = "res://source/interface/menu/Game_over.tscn"
var Tutorial = "res://source/interface/menu/Tutorial.tscn"

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