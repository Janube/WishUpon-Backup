extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	play("Opening")


func _on_continue_pressed():
	print("Need to implement Save feature")


func _on_new_game_pressed():
	# For now, load the scene level
	get_tree().change_scene_to_file("res://scenes/core/main.tscn")


func _on_settings_pressed():
	print("Need to implement Settings feature")


func _on_quit_pressed():
	get_tree().quit()


func _on_level_select_pressed() -> void:
	$Camera2D/MenuList.hide()
	$Camera2D/LevelList.show()


func _on_level_0_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/core/level_zero.tscn")


func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/core/level_one.tscn")


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/core/level_two.tscn")


func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/core/level_three.tscn")


func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/core/level_four.tscn")


func _on_level_5_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/core/level_five.tscn")


func _on_sandbox_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/core/main.tscn")
