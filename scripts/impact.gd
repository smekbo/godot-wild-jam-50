extends Spatial

onready var animationPlayer = $AnimationPlayer
onready var particles = $CPUParticles

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initialize(position, direction):
	set_global_translation(position)
	particles.set_direction(direction)

func destory():
	queue_free()
