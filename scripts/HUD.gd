extends Control

onready var crosshair = $Crosshair
onready var rayHitting = $RayHitting

var rayHitLast = ""
var displayRayHitTime = 1
var displayRayHitTimer = displayRayHitTime

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if displayRayHitTimer >= displayRayHitTime:
		rayHitting.text = ""
		rayHitLast = ""
	if displayRayHitTimer < displayRayHitTime:
		displayRayHitTimer += delta

func updateRayHitLabel(col):
	if (col.to_string() != rayHitLast):
		rayHitting.text = col.to_string()
		displayRayHitTimer = 0
		rayHitLast = col.to_string()
