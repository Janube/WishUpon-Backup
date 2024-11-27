extends Node2D

@export var max_particle_count := 200
@export var particle_size := Vector2(10, 10)
@export var trail_length_squared := 250000.0  # 500^2 to help with performance
@export var trail_spread := 500.0
@export var fade_speed := 1.0
@export var update_frequency := 5  # Update every 5 frames to look folksy or some shit

var particles := []
var particle_pool := []
var asteroid: CharacterBody2D
var frame_counter := 0
var rng := RandomNumberGenerator.new()

func _ready():
	asteroid = get_parent()
	rng.randomize()
	
	# Create particle pool
	for i in max_particle_count:
		var particle = create_particle()
		particle_pool.append(particle)
		add_child(particle)
		particle.visible = false

func create_particle() -> Sprite2D:
	var particle = Sprite2D.new()
	particle.texture = preload("res://assets/art/Graphics/Particle.png")
	particle.scale = particle_size / particle.texture.get_size()
	return particle

func _physics_process(delta):
	frame_counter += 1
	if frame_counter % update_frequency != 0:
		return

	var asteroid_velocity = asteroid.velocity
	var trail_direction = -asteroid_velocity.normalized()
	var velocity_length = asteroid_velocity.length()

	# Spawn new particles
	while particles.size() < max_particle_count and particle_pool.size() > 0:
		var particle = particle_pool.pop_back()
		particle.position = Vector2.ZERO
		particle.modulate.a = rng.randf()
		particle.visible = true
		particles.append(particle)

	var particles_to_remove := []
	for particle in particles:
		# Move particle along the trail
		particle.position += trail_direction * velocity_length * delta * update_frequency
		particle.position += Vector2(rng.randf_range(-trail_spread, trail_spread), rng.randf_range(-trail_spread, trail_spread)) * delta * update_frequency
		
		# Fade out particle
		particle.modulate.a -= fade_speed * delta * update_frequency

		# Check if particle should be removed
		if particle.position.length_squared() > trail_length_squared or particle.modulate.a <= 0:
			particles_to_remove.append(particle)

	# Remove and recycle particles
	for particle in particles_to_remove:
		particles.erase(particle)
		particle.visible = false
		particle_pool.append(particle)

	# Update rotation to match asteroid's current movement direction; this isnt quite right.
	if velocity_length > 0:
		global_rotation = asteroid_velocity.angle()
