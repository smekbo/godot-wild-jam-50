extends KinematicBody

signal hit_player

var direction = Vector3()
var SPEED = 2
var LIFE = 3
var life_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide((direction * SPEED) * delta)
	if collision:
		if collision.get_collider().is_in_group("player"):
			emit_signal("hit_player")
		queue_free()
	if life_timer >= LIFE:
		queue_free()
	life_timer += delta

func direction(target):
	direction = target
