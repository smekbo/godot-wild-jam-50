extends Control

var time = 2
var timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer >= time:
		get_tree().change_scene("res://scenes/main_menu.tscn")
	timer += delta
