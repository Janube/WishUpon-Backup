extends Node2D
@onready var goal = get_node("/root/Main/Black Hole")
@onready var player = get_node("/root/Main/Player")

func _process(_delta: float) -> void:
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	set_pos(Rect2(top_left, size))
	set_rot()

	
	
func set_pos(bounds : Rect2):
	$Sprite2D.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
	$Sprite2D.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()
	
func set_rot():
	var angle = (global_position - player.global_position).angle()
	$Sprite2D.global_rotation = angle
