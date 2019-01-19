extends Node

# variables
var game_time = 60 # in seconds

# scenes
var MainMenu = "res://source/interface/menu/MainMenu.tscn"
var Game = "res://source/Game.tscn"
var Story = "res://source/StoryText.tscn"
var Options = "res://source/interface/menu/Options.tscn"
var Sold = "res://source/interface/menu/Sold.tscn"
var GameOver = "res://source/interface/menu/GameOver.tscn"
var Tutorial = "res://source/interface/menu/Tutorial.tscn"
var EndingOld = "res://source/interface/menu/Ending.tscn"
var Ending = "res://source/Ending.tscn"

# classes
var DoomsdaySurfer = load("res://source/units/DoomsdaySurfer.tscn")
var KaijuPlant = load("res://source/units/KaijuPlant.tscn")
var PowerCollector = load("res://source/units/PowerCollector.tscn")
var Survivors = load("res://source/units/Survivors.tscn")

var Marker = load("res://source/interface/gui/Marker.tscn")

var EnemyKaiju = load("res://source/units/EnemyKaiju.tscn")

var Disaster = load("res://source/items/Disaster.tscn")
var PowerCell = load("res://source/items/PowerCell.tscn")
var Food = load("res://source/items/Food.tscn")

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