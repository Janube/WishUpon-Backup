extends RigidBody2D

# Node references - @onready ensures these are only set after the node is in the scene tree
@onready var aiming = false              # Tracks if player is currently aiming
@onready var strength = $Anchor/Strength # Reference to the strength meter UI element
@onready var anchor = $Anchor           # Reference to the anchor point for rotation/aiming
@onready var planet = get_node("/root/Main/Planet")
@onready var music = get_node("/root/Main/AudioManager/Music")
@onready var main_scene = get_node("/root/Main")
@onready var goal = get_node("/root/Main/Black Hole")
@onready var hud = get_node("/root/Main/HUD")

# Configurable parameters
@export var impulse_multiplier = 2      # Multiplier for shot power - expose to editor for easy tuning
@export var speed = 10

# Variable declarations
var mouse_pos    		# Stores current mouse position in global coordinates
var dir          		# Normalized direction vector from mouse to player
var impulse      		# Final force vector to be applied when shooting
var can_fire = true		# Allows cooldown between shots
var event_horizon_entry # 
var available
var shot = 0
var stardust: float = 0
var stardustperc
var attempts = GlobalVariables.attempts
var stardustmax: float

func _ready():
	# Initialize the strength meter
	strength.hide()           # Hide strength meter on start
	strength.value = 0        # Reset strength value
	add_to_group("player")
	await get_tree().process_frame
	var stardustarray = get_tree().get_nodes_in_group("stardust")
	stardustmax = stardustarray.size()

func _process(_delta):
	anchor.rotation = (get_global_mouse_position() - position).angle() # Update anchor rotation and strength bar to point towards mouse
	# The Anchor Node exists so that the Strength meter can be set to an offset and rotated around the Anchor
	mouse_pos = get_global_mouse_position() # Update mouse position and calculate direction
	dir = Vector2(position - mouse_pos).normalized()  # Direction from mouse to player, normalized
	
	# Velocity-based cooldown for shooting [OFF DURING DEVELOPMENT]
	#if abs(linear_velocity) <= Vector2(50,50): 
	can_fire = true # Indent when switching velocity-based cooldown on
	
	# Handle aiming input
	if Input.is_action_pressed("aim1") and can_fire == true:
		strength.show()  # Show strength meter while aiming
		
		# OPTION 1: Distance-based strength
		strength.value = get_global_mouse_position().distance_to(position)
		# OPTION 2: Time-based strength [deprecated]
		#strength.value += 5
	
	# Handle shooting when aim1 is released
	if Input.is_action_just_released("aim1") and can_fire == true:
		if strength.value > 0:
			impulse = (strength.value * dir) * impulse_multiplier  # Calculate Impulse
			self.sleeping = true # Prevents previous momentum from impacting shot trajectory
			shoot()
			strength.value = 0  # Reset strength
			strength.hide()     # Hide strength meter
		
	if Input.is_action_pressed("aim2") and available == true: # Nothing sets available to true right now
			can_fire = true
			time_slow()

	if not Input.is_action_pressed("aim2"):
		time_normal()
	
	if event_horizon_entry == true:
		$PlayerSprite.scale *= Vector2(.95,.95)
		

	
func _physics_process(_delta):
	# Reserved for future physics calculations if needed
	pass
	
func shoot():
	time_normal()
	if planet != null:
		planet.orbiting = false # Allows you to leave orbit on shoot
	$Exhaust.process_material.set("initial_velocity", impulse) # Fart-particles at location of impulse
	$Exhaust.set_emitting(true)
	can_fire = false # Cooldown
	apply_central_impulse(impulse) # Apply the calculated impulse force to the Player Character
	shot += 1
	hud.update_shots(shot)
	
func time_slow(): # Slows down time, zooms in, warps music
	var slow_tween = get_tree().create_tween()
	slow_tween.parallel().tween_property($Camera2D,"zoom",Vector2(1.2,1.2),0.3) # Zoom in 20%
	slow_tween.parallel().tween_property(Engine,"time_scale", 0.5, 0.3) #Slow time 50%
	slow_tween.parallel().tween_property(music,"pitch_scale", 0.7, 0.3) #Slow music 30%

func time_normal(): # Returns to normal parameters from time_slow
	var slow_tween = get_tree().create_tween()
	slow_tween.parallel().tween_property(Engine,"time_scale", 1, 0.15) # Return to normal time
	slow_tween.parallel().tween_property(music,"pitch_scale", 1, 0.15) # Return to normal music
	slow_tween.parallel().tween_property($Camera2D,"zoom",Vector2(1,1),0.15) # Return to normal zoom
	
func event_horizon():
	event_horizon_entry = true

func nebula_enter():
	$AnimatedSprite2D.self_modulate.a = 0.5
	
func nebula_leave():
	$AnimatedSprite2D.self_modulate.a = 1
	
func acquire_stardust():
	stardust += 1
	hud.update_stardust(stardust)
	stardustperc = (stardust / stardustmax) * 100
	hud.update_stardustperc(stardustperc)


func die():
	%Death.play()
	set_process(false)
	set_collision_layer_value(1,0)
	$AnimatedSprite2D.hide()
	linear_damp = 3
	$Deathpop.set_emitting(true)
	hud.update_attempts(attempts)
	await get_tree().create_timer(3).timeout
	#Restart level
	GlobalVariables.attempts += 1
	get_tree().reload_current_scene() #"res://scenes/MainMenu.tscn") go back to main menu
	

# This still needs all of the work, but something to this effect might work for orbit.
#func orbit(planetPosition):
	#set_sleeping(true)
	#set_linear_velocity(Vector2(0, 0))
	#var offset = global_position - planetPosition
	#set_global_position(planetPosition)
	#offsetGroup.set_position(offset)

# This should be moved to a level script instead
func _on_level_boundary_body_exited(body):
	if body.is_in_group("player"):
		body.die()

# CUSTOMIZATION:
# - Adjust impulse_multiplier in editor to modify shot power
# - Uncomment time-based strength option if preferred
# - Consider adding min/max strength limits
# - Add a way to manually cancel shot preparation
# - Add finite "ammo" to time-slows (increasing difficulty gives less "ammo")
# - Add shot counter and time counter
# - Project Settings - Physics - 2D - Advanced - Default Linear Ramp - alters inertia for the engine OR Linear -> Damp in Player Node for just the Player
#
# PHYSICS CONSIDERATIONS:
# - Uses central impulse for realistic physics-based movement
# - Ensure RigidBody2D mass and gravity scale are configured appropriately
#
# ISSUES:
# - Fart particles don't "pop" enough
#
# DAILY GOAL:
#
# WEEKLY GOALS:
# - Asteroids (static and pathing)
# - Boundaries (elastic bounce just past edge - camera doesn't show past edge)
# - Add clamp to velocity value so you can't exceed a certain speed for gravity shenanigans
# - Design sand trap nebula that dampens velocity - audio bus to dampen music?
