extends StaticBody2D
@export var orbit_speed = 1
@onready var player_node = get_node("/root/Main/Player")
var size_multiplier
var orbiting
var orbit_angle

func _ready():
	size_multiplier = randi_range(4,4)
	self.scale = Vector2(size_multiplier,size_multiplier)
	var rad = get_node("PlanetCollision").shape.radius
	$PlanetGravity/GravityCollision.shape.radius = rad
	$PlanetGravity/GravityCollision.scale *= 1.35
	
func _physics_process(_delta):
	pass
	
func _process(delta):
	if orbiting == true:
		orbit_player(delta)

func _on_planet_gravity_body_entered(body):
	if body.is_in_group("player"):
		#body.orbit(global_position)
		begin_orbit(body)
		
func begin_orbit(player):
	orbiting = true
	orbit_angle = (player.global_position - global_position).angle()
	
func orbit_player(delta):
	var radius = $PlanetGravity/GravityCollision.shape.radius
	orbit_angle += orbit_speed * delta
	var new_position = global_position + Vector2(cos(orbit_angle), sin(orbit_angle)) * radius * size_multiplier * 1.35
	player_node.global_position = new_position
	player_node.linear_velocity = Vector2.ZERO
