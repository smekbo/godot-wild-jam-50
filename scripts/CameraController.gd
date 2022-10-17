extends Camera

var lookSensitivity : float = 15.0
var minLookAngle : float = -60.0
var maxLookAngle : float = 30.0

var mouseDelta : Vector2 = Vector2()

var captureMouse = false

onready var player = get_parent()

func _input(event):
	if event is InputEventMouseButton:
		if not captureMouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			captureMouse = true
	if event is InputEventMouseMotion:
		mouseDelta = event.relative
		
func _process(delta):
	var rot = Vector3(mouseDelta.y, mouseDelta.x, 0) * lookSensitivity * delta
	rotation_degrees.x -= rot.x
	rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
	
	player.rotation_degrees.y -= rot.y
	
	mouseDelta = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
