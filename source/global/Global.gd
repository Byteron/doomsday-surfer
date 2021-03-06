extends Node

# variables
var defeat_reason = null

# scenes
var DoomsdaySurferTutorial = "res://source/game/tutorials/DoomsdaySurferTutorial.tscn"
var PowerCollectorTutorial = "res://source/game/tutorials/PowerCollectorTutorial.tscn"
var SurvivorsTutorial = "res://source/game/tutorials/SurvivorsTutorial.tscn"
var KaijuPlantTutorial = "res://source/game/tutorials/KaijuPlantTutorial.tscn"

var MainMenu = "res://source/interface/menu/MainMenu.tscn"
var Game = "res://source/game/Game.tscn"
var Story = "res://source/interface/menu/StoryText.tscn"
var Credits = "res://source/interface/menu/Credits.tscn"
var Controls = "res://source/interface/menu/Controls.tscn"
var Options = "res://source/interface/menu/Options.tscn"
var Sold = "res://source/interface/menu/Sold.tscn"
var GameOver = "res://source/interface/menu/GameOver.tscn"
var Tutorial = "res://source/interface/menu/Tutorial.tscn"
var EndingOld = "res://source/interface/menu/Ending.tscn"
var Ending = "res://source/interface/menu/Ending.tscn"

# classes
var DoomsdaySurfer = load("res://source/units/DoomsdaySurfer.tscn")
var KaijuPlant = load("res://source/units/KaijuPlant.tscn")
var PowerCollector = load("res://source/units/PowerCollector.tscn")
var Survivors = load("res://source/units/Survivors.tscn")

var Marker = load("res://source/interface/gui/Marker.tscn")

var EnemyKaiju = load("res://source/units/EnemyKaiju.tscn")

var Tsunami = load("res://source/disasters/Tsunami.tscn")
var Lava = load("res://source/disasters/Lava.tscn")
var Earthquake = load("res://source/disasters/Earthquake.tscn")
var Tornado = load("res://source/disasters/Tornado.tscn")
var Thunder = load("res://source/items/Flash.tscn")

var PowerCell = load("res://source/items/PowerCell.tscn")
var Food = load("res://source/items/Food.tscn")

var PopupText = load("res://source/interface/gui/PopupText.tscn")

# textures
var tsunami_tex = load("res://graphics/disasters/tsunami/tsunami.png")
var lava_tex = load("res://graphics/disasters/lava/lava.png")
var earthquake_tex = load("res://graphics/disasters/earthquake/earthquake.png")
var tornado_tex = load("res://graphics/disasters/tornado/tornado.png")