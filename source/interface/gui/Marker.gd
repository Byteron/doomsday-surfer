extends Sprite

var location = null
var next_location = null

func animate():
	$AnimationPlayer.play("fade_in")
