extends KinematicBody

var moveSpeed : float = 6.0
var jumpForce : float = 5.0
var gravity : float = 15.0

var vel : Vector3 = Vector3()

onready var attackRayCast = $Camera/Gun/AttackRayCast
onready var hud = $HUD

func _ready():
	pass

func _physics_process(delta):
	vel.x = 0
	vel.z = 0

	var input = Vector3()
	
	if Input.is_action_pressed("movement_forward"):
		input.z += 1
	if Input.is_action_pressed("movement_backward"):
		input.z -= 1
	if Input.is_action_pressed("movement_left"):
		input.x += 1
	if Input.is_action_pressed("movement_right"):
		input.x -= 1
	
	input = input.normalized()
	
	var dir = (transform.basis.z * input.z + transform.basis.x * input.x)
	var mov = moveSpeed
	
	vel.x = dir.x * mov
	vel.z = dir.z * mov
	
	#gravity
	vel.y -= gravity * delta
	
	if Input.is_action_just_released("movement_jump") and is_on_floor():
		vel.y = jumpForce

	vel = move_and_slide(vel, Vector3.UP)
	
	#Raycast
	var collision = attackRayCast.get_collider()
	if (collision):
		hud.updateRayHitLabel(collision)
