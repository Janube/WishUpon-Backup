extends Node2D

@export var player_scene: PackedScene
@onready var spawn_point = $PlayerSpawn
func _ready():
	spawn_player()

func spawn_player():
	var player = player_scene.instantiate()
	add_child(player)
	player.global_position = spawn_point.global_position
