extends Node

var enemy = preload("res://scenes/enemy.tscn")

onready var target = $"../Player"
onready var spawnPoints = $spawnPoints
onready var enemies = $enemies

var spawnTime = 1
var spawnTimer = 0

var maxEnemies = 20
var enemyCount = 0

func _process(delta):
	if spawnTimer >= spawnTime and enemyCount < maxEnemies:
		spawnEnemy()
		spawnTimer = 0
	spawnTimer += delta
	if spawnTimer > spawnTime:
		spawnTimer = spawnTime
		
	if enemies.get_child_count() > 0:
		for child in enemies.get_children():
			child.setTarget(target)
			child.decideWhatToDo()

func spawnEnemy():
	var e = enemy.instance()
	enemies.add_child(e)
	e.connect("enemy_died", self, "onEnemyDie")
	var spawnindex = randi() % spawnPoints.get_children().size() - 1
	var spawn = spawnPoints.get_children()[spawnindex]
	e.set_global_translation(spawn.global_translation)
	
	enemyCount += 1

func onEnemyDie():
	enemyCount -= 1
