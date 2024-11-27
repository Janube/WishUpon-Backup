extends Node2D

@onready var hud = get_node("/root/Main/HUD")

func _ready():
	add_to_group("stardust")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		$CollectAudio.play()
		body.acquire_stardust()
		queue_free()
