extends Spatial

onready var player1pos = $Positions/Player1Pos
onready var player2pos = $Positions/Player2Pos
onready var EnemyPos = $Positions/EnemyPos
onready var EnemyPos2 = $Positions/EnemyPos2
onready var EnemyPos3 = $Positions/EnemyPos3
onready var EnemyPos4 = $Positions/EnemyPos4
onready var EnemyPos5 = $Positions/EnemyPos5
onready var Enemies = 4


func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	var player1 = preload("res://Player/Player.tscn").instance()
	player1.name = "Player1"
	player1.global_transform = player1pos.global_transform
	add_child(player1)
	var enemy = preload("res://Enemy/Enemy.tscn").instance()
	enemy.global_transform = EnemyPos.global_transform
	add_child(enemy)
	var enemy2 = preload("res://Enemy/Enemy.tscn").instance()
	enemy2.global_transform = EnemyPos2.global_transform
	add_child(enemy2)
	var enemy3 = preload("res://Enemy/Enemy.tscn").instance()
	enemy3.global_transform = EnemyPos3.global_transform
	add_child(enemy3)
	var enemy4 = preload("res://Enemy/Enemy.tscn").instance()
	enemy4.global_transform = player1pos.global_transform
	add_child(enemy4)
	var enemy5 = preload("res://Enemy/Enemy.tscn").instance()
	enemy5.global_transform = EnemyPos4.global_transform
	add_child(enemy5)
	var enemy6 = preload("res://Enemy/Enemy.tscn").instance()
	enemy6.global_transform = EnemyPos5.global_transform
	add_child(enemy6)
	if Enemies == 0:
		$GameOverScreen.show()
		

