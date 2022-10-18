extends Spatial

onready var animationTree = $AnimationTree
var blastReady = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func blastem():
	animationTree["parameters/OneShot/active"] = true
	
func isBlastReady():
	return !animationTree["parameters/OneShot/active"]

func finishedBlastin():
	blastReady = true
