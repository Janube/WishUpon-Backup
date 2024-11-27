extends Node

var pauseMenuOpened : bool = false
var pause
@onready var scene = preload("res://scenes/core/PauseMenu.tscn")

func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause") and not pauseMenuOpened:
		pause = scene.instantiate()
		pauseMenuOpened = true
		add_child(pause)
		get_tree().paused = true
		
	elif Input.is_action_just_pressed("pause") and pauseMenuOpened:
		var resume = get_node("/root/CommandManager/PauseMenu")
		get_tree().paused = false
		pauseMenuOpened = false
		if is_instance_valid(resume):
			resume._on_resume_pressed()
