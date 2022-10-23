extends KinematicBody

var vel : Vector3 = Vector3()

var MAXHEALTH = 5
var health = MAXHEALTH

var ritual_tick_time = 0.2
var ritual_tick_timer = 0

var invincible = false
var altar_in_range = false

#MOVEMENT
var moveSpeed : float = 8.0
var jumpForce : float = 6.0
var gravity : float = 15.0

#GUN
var blastForce : float = .2
onready var impact = preload("res://scenes/impact.tscn")
onready var muzzleFlash = preload("res://scenes/muzzle_flash.tscn")

#HAND
onready var hand = $Camera/Gun/hand

#ALTAR
onready var altar = $"../altar"

onready var attackRayCast = $Camera/Gun/AttackRayCast
onready var hud = $HUD
onready var camera = $Camera
onready var crosshair = $HUD/Crosshair

onready var blaster = $Camera/Gun/blaster
onready var muzzleFlashLocation = $Camera/Gun/blaster/blastEffect
onready var viewportAnimation = $AnimationPlayer

func _ready():
	add_to_group("player")
	hand.set_altar(altar)

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
	
	if Input.is_action_just_pressed("movement_jump") and is_on_floor():
		vel.y = jumpForce

	if Input.is_action_pressed("fire"):
		if blaster.isBlastReady():
			# activate muzzle effect and gun animation
			fire()
			blaster.blastem()
			
			# get raycat collision
			var collision = attackRayCast.get_collider()
			
			# show the impact 
			if (collision):
				var position = attackRayCast.get_collision_point()
				# get direction to collision by subtracting collision vector from player's vector 
				var direction = (position - global_translation) * blastForce
				
				show_impact(position, direction, collision)
				hud.updateRayHitLabel(collision)
				if "enemy" in collision.to_string():
					collision.takeDamage(1)
				if (collision.get_class() == "RigidBody"):
					collision.apply_impulse(position, direction)

	ritual_tick_timer += delta
	if Input.is_action_pressed("ritual") and altar_in_range:
		if (ritual_tick_timer >= ritual_tick_time):
			hud.updateRitualProgress(2)
			ritual_tick_timer = 0

	if Input.is_action_just_pressed("ritual"):
		hand.ritual(altar_in_range)
	if Input.is_action_just_released("ritual"):
		hand.idle()

	vel = move_and_slide(vel, Vector3.UP)
	
func show_impact(position, direction, object):
	var i = impact.instance()
	get_tree().get_current_scene().add_child(i)
	i.initialize(position, direction)

func fire():
	var m = muzzleFlash.instance()
	add_child(m)
	m.set_global_translation(muzzleFlashLocation.global_translation)

func take_damage():
	if !invincible:
		blaster.got_hit()
		viewportAnimation.play("damage")
		health -= 1
		hud.updateHealth(MAXHEALTH, health)
		if health <= 0:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene("res://scenes/lose.tscn")

func enter_altar_range():
	hand.enter_range()
	altar_in_range = true
	
func exit_altar_range():
	hand.out_range()
	altar_in_range = false

func start_iframes():
	invincible = true

func end_iframes():
	invincible = false
