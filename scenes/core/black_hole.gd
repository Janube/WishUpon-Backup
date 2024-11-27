extends Node2D

func _ready():
	#$Sprite2D4/AnimationPlayer.play("black_hole")
	pass
	
func _process(_delta):
	rotation += 0.02

func _on_event_horizon_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.event_horizon()
