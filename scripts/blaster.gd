extends Spatial


onready var animationTree = $AnimationTree


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func blastem():
	animationTree["parameters/OneShot/active"] = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
