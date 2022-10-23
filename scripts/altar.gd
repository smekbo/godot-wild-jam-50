extends Spatial

signal player_in_range
signal player_out_range

onready var player = $"../Player"
onready var area = $Area

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("player_in_range", player, "enter_altar_range")
	connect("player_out_range", player, "exit_altar_range")
	pass # Replace with function body.


func _on_Area_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("player_in_range")

func _on_Area_body_exited(body):
	if body.is_in_group("player"):
		emit_signal("player_out_range")
