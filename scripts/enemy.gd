extends RigidBody

signal enemy_died

onready var projectile = preload("res://scenes/enemy_attack.tscn")

var health = 1
var SPEED = 10

var ATTACK_SPEED = 1
var ATTACK_DIST = 15

var attack_timer = 0

var dying = false
var despawnTime = 2
var despawnTimer = 0

var decision = "idle"
var target = ""
var path = []
var pathRefreshTime = .5
var pathRefreshTimer = 0

func _ready():
	mode = MODE_KINEMATIC

func _physics_process(delta):
	if dying:
		despawnTimer += delta
	if despawnTimer >= despawnTime:
		emit_signal("enemy_died")
		queue_free()
	
	if !dying:
		decideWhatToDo()
		if decision == "attack":
			if attack_timer >= ATTACK_SPEED:
				attack()
				attack_timer = 0
			attack_timer += delta
			
		if decision == "move":
			if path.size() < 1 or pathRefreshTimer >= pathRefreshTime:
				getPathToTarget()
				pathRefreshTimer = 0
			moveTowardsTarget(delta)
			pathRefreshTimer += delta

func moveTowardsTarget(delta):
	var direction = Vector3()

	# We need to scale the movement speed by how much delta has passed,
	# otherwise the motion won't be smooth.
	var step_size = delta * SPEED

	if path.size() > 0:
		# Direction is the difference between where we are now
		# and where we want to go.
		var destination = path[0]
		direction = destination - global_translation

		# If the next node is closer than we intend to 'step', then
		# take a smaller step. Otherwise we would go past it and
		# potentially go through a wall or over a cliff edge!
		if step_size > direction.length():
			step_size = direction.length()
			# We should also remove this node since we're about to reach it.
			path.remove(0)

		# Move the robot towards the path node, by how far we want to travel.
		# Note: For a KinematicBody, we would instead use move_and_slide
		# so collisions work properly.
		global_translation += direction.normalized() * step_size

		# Lastly let's make sure we're looking in the direction we're traveling.
		# Clamp y to 0 so the robot only looks left and right, not up/down.
		direction.y = 0
		if direction:
			# Direction is relative, so apply it to the robot's location to
			# get a point we can actually look at.
#			var look_at_point = global_translation + direction.normalized()
			# Make the robot look at the point.
			look_at(target.global_translation, Vector3.UP)

func getPathToTarget():
	for map in NavigationServer.get_maps():
		if (NavigationServer.map_get_regions(map).size() > 0):
			path = NavigationServer.map_get_path(map, global_translation, target.global_translation, true)

func setTarget(target):
	self.target = target

func attack():
	look_at(target.global_translation, Vector3.UP)
	var bullet = projectile.instance()
	bullet.global_translation = $bullet_spawn.global_translation
	bullet.direction(target.global_translation - global_translation)
	get_tree().get_current_scene().add_child(bullet)
	bullet.connect("hit_player", target, "take_damage")

func takeDamage(damage):
	health -= damage
	if health <= 0:
		mode = MODE_RIGID
		dying = true

func decideWhatToDo():
	if global_translation.distance_to(target.global_translation) < ATTACK_DIST:
		decision = "attack"
	else:
		decision = "move"
	pass
