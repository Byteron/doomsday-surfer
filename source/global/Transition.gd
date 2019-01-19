extends CanvasLayer

var next_scene = null

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished")
	_fade_in()

func change_scene(scene):
	next_scene = scene
	_fade_out()

func _fade_in():
	$AnimationPlayer.play("FadeIn")

func _fade_out():
	$AnimationPlayer.play("FadeOut")

func _on_animation_finished(anim):
	if anim == "FadeOut":
		_fade_in()
		get_tree().change_scene(next_scene)