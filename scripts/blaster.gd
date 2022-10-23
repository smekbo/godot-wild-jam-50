extends Spatial

onready var animationTree = $AnimationTree
onready var audio = $AudioStreamPlayer
onready var blastSound = preload("res://assets/sfx/Realistic Gunshot Sound Effect.mp3")
onready var rng = RandomNumberGenerator.new()
var blastReady = true

# Called when the node enters the scene tree for the first time.
func _ready():
	audio.stream = blastSound
	audio.stream.loop = false
	pass # Replace with function body.

func blastem():
	var scale = rng.randf_range(.9, 1.2)
	audio.set_pitch_scale(scale)
	audio.play()
	animationTree["parameters/Blend2/blend_amount"] = 0
	animationTree["parameters/OneShot/active"] = true
	
func isBlastReady():
	return !animationTree["parameters/OneShot/active"]

func finishedBlastin():
	blastReady = true

func got_hit():
	animationTree["parameters/Blend2/blend_amount"] = 1
	animationTree["parameters/OneShot/active"] = true
	
