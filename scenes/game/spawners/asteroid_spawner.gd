extends Node2D

@export var asteroid_scene: PackedScene
@export var asteroid_spawn_speed: float = 200.0
@export var despawn_time: float = 0.0
@export var spawn_spacing: float = 2.0  

@onready var spawn_spacing_in_seconds: Timer = $Timer
@onready var spawn_direction: Vector2

func _ready():
	spawn_spacing_in_seconds.wait_time = spawn_spacing
	spawn_spacing_in_seconds.timeout.connect(spawn_asteroid)
	spawn_spacing_in_seconds.start()
	spawn_direction = $TrajectoryMarker.global_position - global_position#Vector2.UP

func spawn_asteroid():
	print("Trying to spawn asteroid...")
	
	if not asteroid_scene:
		print("No asteroid scene set!")
		return
		
	var asteroid = asteroid_scene.instantiate()
	asteroid.position = global_position
	
	asteroid.initialize(spawn_direction, asteroid_spawn_speed, 1.0, despawn_time)
	get_parent().add_child(asteroid)
	
	if get_parent().has_method("_connect_asteroid"):
		get_parent()._connect_asteroid(asteroid)
