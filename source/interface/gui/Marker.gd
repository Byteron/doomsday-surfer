extends Sprite

var fade_time = 5

var location = null
var next_location = null

func _ready():
	animate()

func animate():
	$Tween.interpolate_property(self, "self_modulate", Color("00ffffff"), Color("ffffffff"), fade_time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func stop():
	$Tween.stop_all()