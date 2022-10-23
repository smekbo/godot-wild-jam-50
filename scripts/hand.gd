extends Spatial

onready var animationTree = $AnimationTree
onready var light = $OmniLight
onready var range_indicator = $OmniLight

var performingRitual = false
onready var altar = $"."
var cameraRot

func _process(delta):
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	range_indicator.hide()
	pass # Replace with function body.

func set_altar(altar):
	self.altar = altar

func set_camera_rotation(rot):
	cameraRot = rot

func ritual(altar_in_range):
	performingRitual = true
	if altar_in_range:
		range_indicator.show()
	animationTree["parameters/Transition/current"] = 1

func idle():
	performingRitual = false
	range_indicator.hide()
	animationTree["parameters/Transition/current"] = 0

func damage():
	performingRitual = false
	animationTree["parameters/OneShot/active"] = true

func enter_range():
	if performingRitual:
		range_indicator.show()

func out_range():
	range_indicator.hide()
