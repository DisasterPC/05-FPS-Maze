extends Spatial

onready var player1pos = $Player1Pos
onready var player2pos = $Player2Pos
var enemies = 0

func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	var player1 = preload("res://Player/Player.tscn").instance()
	player1.name = "Player1"
	player1.global_transform = player1pos.global_transform
	add_child(player1)
	var enemy = preload("res://Enemy/Enemy.tscn").instance()
	enemy.global_transform = player2pos.global_transform
	add_child(enemy)


