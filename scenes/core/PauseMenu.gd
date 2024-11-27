extends CanvasLayer

signal game_paused 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _on_resume_pressed():
	queue_free()
	get_tree().paused = false

func _on_settings_pressed():
	print("Need to implement Settings feature")


func _on_main_menu_pressed():
	# Return to Main Menu
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
	queue_free()


func _on_exit_pressed():
	get_tree().quit()
