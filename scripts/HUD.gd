extends Control

onready var crosshair = $Crosshair
onready var rayHitting = $RayHitting

var rayHitLast = ""
var displayRayHitTime = 1
var displayRayHitTimer = displayRayHitTime


onready var health = $health/border/value
onready var ritual = $ritual/border/value
var maxHealthWidth = 0
var maxRitualWidth = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	maxHealthWidth = health.get_rect().size.x
	maxRitualWidth = ritual.get_rect().size.x
	
	ritual.set_size(Vector2(0, ritual.get_rect().size.y))
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

func updateRitualProgress(percent):
	if percent > 1:
		percent = percent / 100.0
	
	var size = (percent * maxRitualWidth) + ritual.get_rect().size.x
	if size > maxRitualWidth:
		size = maxRitualWidth
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene("res://scenes/win.tscn")
		
	ritual.set_size(Vector2(size, ritual.get_rect().size.y))

func updateHealth(maxHealth, playerHealth):
	var size = (maxHealthWidth / maxHealth) * playerHealth
	if size < 0:
		size = 0
	health.set_size(Vector2(size, health.get_rect().size.y))
