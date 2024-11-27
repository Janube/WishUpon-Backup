extends RigidBody2D

signal split_asteroid(spawn_position, new_size, new_direction1, new_direction2, split_speed)
signal asteroid_split

var speed: float = 100.0
var direction: Vector2 = Vector2.RIGHT
var rotation_speed: float = 0.0
var size: float = 1.0

@export var min_rotation_speed: float = -1.0
@export var max_rotation_speed: float = 1.5

@export var split_speed_threshold: float = 500.0  #Higher should make it harder to split an asteroid...in theory.

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var trail = $AsteroidTrail

var ignore_player_timer: float = 0.0
var ignore_asteroid_timer: float = 0.0
const IGNORE_PLAYER_DURATION: float = 0.5
const IGNORE_ASTEROID_DURATION: float = 0.5

var split_direction: Vector2
var split_position: Vector2

var prev_position: Vector2

func _ready():
	add_to_group("asteroids")
	gravity_scale = 0.0
	contact_monitor = true
	max_contacts_reported = 1
	
	if not has_node("Sprite2D"):
		push_warning("Asteroid scene is missing Sprite2D node!")
	else:
		sprite = $Sprite2D
	
	if not has_node("CollisionShape2D"):
		push_warning("Asteroid scene is missing CollisionShape2D node!")
	else:
		collision_shape = $CollisionShape2D
	
	generate_random_rotation_speed()
	
	# Apply initial size
	if sprite:
		sprite.scale = Vector2(size, size)
	if collision_shape:
		collision_shape.scale = Vector2(size, size)
	update_visual_size()

	# Initialize the trail
	if not has_node("AsteroidTrail"):
		var trail_scene = load("res://scenes/core/asteroid_trail.gd")
		trail = trail_scene.new()
		trail.name = "AsteroidTrail"
		add_child(trail)

	# Remove the shader-based trail
	if sprite and sprite.material:
		sprite.material = null
	
	prev_position = global_position

func generate_random_rotation_speed():
	rotation_speed = randf_range(min_rotation_speed, max_rotation_speed)

func initialize(new_direction: Vector2, new_speed: float, new_size: float, new_texture: Texture2D):
	direction = new_direction
	speed = new_speed
	size = new_size
	if sprite:
		sprite.scale = Vector2(size, size)
		sprite.texture = new_texture  # Set the provided texture
		print("Sprite texture set to: ", new_texture)
		print("Sprite visible: ", sprite.visible)
		print("Sprite modulate: ", sprite.modulate)
	else:
		push_warning("Sprite node not found in asteroid scene!")
	if collision_shape:
		collision_shape.scale = Vector2(size, size)
	else:
		push_warning("CollisionShape2D node not found in asteroid scene!")
	generate_random_rotation_speed()
	linear_velocity = direction * speed
	ignore_player_timer = IGNORE_PLAYER_DURATION
	ignore_asteroid_timer = IGNORE_ASTEROID_DURATION
	collision_mask = collision_mask | 2
	print("Asteroid initialized with size: ", size, " and speed: ", speed)
	print("Sprite scale: ", sprite.scale if sprite else "No sprite")
	print("Collision shape scale: ", collision_shape.scale if collision_shape else "No collision shape")
	update_visual_size()

func _physics_process(delta):
	if sprite:
		sprite.rotation += rotation_speed * delta
		#Size label for debugging
		if not sprite.has_node("SizeLabel"):
			var label = Label.new()
			label.name = "SizeLabel"
			sprite.add_child(label)
		var size_label = sprite.get_node("SizeLabel")
		size_label.text = str(size).substr(0, 4)
		size_label.position = Vector2(-size_label.size.x / 2, -size_label.size.y / 2)
	
	if ignore_player_timer > 0:
		ignore_player_timer -= delta
	if ignore_asteroid_timer > 0:
		ignore_asteroid_timer -= delta
	
	# Update shader direction
	if sprite and sprite.material:
		var current_direction = (global_position - prev_position).normalized()
		if current_direction != Vector2.ZERO:
			sprite.material.set_shader_parameter("direction", current_direction)
	
	prev_position = global_position

func split():
	if size > 0.25:  # Only split if the asteroid is large enough
		var new_size = size / 2  # New asteroids = half as big
		var spawn_position = global_position
		var current_speed = linear_velocity.length()
		var split_speed = current_speed * 1.5  # Increase speed of split asteroids
		
		var current_direction = linear_velocity.normalized()
		var perpendicular = Vector2(-current_direction.y, current_direction.x)
		var new_direction1 = (current_direction + perpendicular).normalized()
		var new_direction2 = (current_direction - perpendicular).normalized()
		
		emit_signal("split_asteroid", spawn_position, new_size, new_direction1, new_direction2, split_speed)
	
	queue_free()  # Remove the original asteroid

func get_size():
	return size

func _on_body_entered(body):
	var body_velocity = Vector2.ZERO
	var body_mass = 1.0  # Default mass

	if body.is_in_group("player"):
		body_velocity = body.velocity  # Use Character velo
		body_mass = body.mass if "mass" in body else 1.0  # Use player's defined mass or 1.0 as fallback
	elif body.is_in_group("asteroids"):
		body_velocity = body.linear_velocity  
		body_mass = body.mass
	
	var relative_speed = (linear_velocity - body_velocity).length()
	
	if relative_speed > split_speed_threshold:
		if (body.is_in_group("player") and ignore_player_timer <= 0) or (body.is_in_group("asteroids") and ignore_asteroid_timer <= 0):
			split()
	else:
		# Apply physics interaction without splitting
		if body.is_in_group("player"):
			# Calculate impulse based on relative velocity and masses
			var impulse = (body_velocity - linear_velocity) * body_mass
			apply_central_impulse(impulse)
		elif body.is_in_group("asteroids"):
			# Asteroid-asteroid collisions will be handled by physics engine
			pass

	# Reset ignore timers
	if body.is_in_group("player"):
		ignore_player_timer = IGNORE_PLAYER_DURATION
	elif body.is_in_group("asteroids"):
		ignore_asteroid_timer = IGNORE_ASTEROID_DURATION

func set_split_info(direction: Vector2, position: Vector2):
	split_direction = direction
	split_position = position

func update_visual_size():
	if sprite:
		sprite.scale = Vector2(size, size)
	if collision_shape:
		collision_shape.scale = Vector2(size, size)
	print("Updated visual size. Sprite scale: ", sprite.scale if sprite else "No sprite")
