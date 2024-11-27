extends CharacterBody2D

@onready var trail = $AsteroidTrail
@export var min_rotation_speed: float = -1.0
@export var max_rotation_speed: float = 1.5
@export var movement_speed: float
@export var movement_direction: Vector2
var rotation_speed: float = 0.0
var despawn_time: float = 0.0 

func _ready():
	add_to_group("asteroids")
	rotation_speed = randf_range(min_rotation_speed, max_rotation_speed)
	
	if despawn_time > 0:
		var timer = get_tree().create_timer(despawn_time)
		timer.timeout.connect(queue_free)
	
func _process(delta: float) -> void:
	rotation += rotation_speed * delta

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()
		
func initialize(direction: Vector2, speed: float, size: float, despawn: float = 0.0) -> void:
	movement_direction = direction
	movement_speed = speed
	scale = Vector2(size, size)
	despawn_time = despawn
	
func _physics_process(delta: float) -> void:
	velocity = movement_direction * movement_speed
	move_and_slide()
