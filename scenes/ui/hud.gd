extends CanvasLayer

@onready var time_label = %TimeLabel
@onready var timer = %Timer
@onready var shot_count = %ShotCount
@onready var attempt_count = %Attempts
@onready var stardust_count = %StardustCount
@onready var stardustpercent = %StardustPercent
@onready var total_time_centseconds : int = 00000000

func _ready():
	%Timer.start()
	attempt_count.text = str("Attempts: {attempts}").format({"attempts":"%0.0f" % GlobalVariables.attempts})
	
func update_shots(shot):
	shot_count.text = str("{shot} Shots Taken").format({"shot":"%0.0f" % shot})
	
func update_attempts(attempts):
	attempt_count.text = str("Attempts: {attempts}").format({"attempts":"%0.0f" % attempts})
	
func update_stardust(stardust):
	stardust_count.text = str("{stardust} Stardust Found").format({"stardust":"%0.0f" % stardust})
	
func update_stardustperc(stardustperc):
	stardustpercent.text = str("{stardustperc}%").format({"stardustperc":"%0.0f" % stardustperc})
	#"Hi, {0} v{version}".format({0:"Godette", "version":"%0.2f" % 3.114})
	
#func update_escaped(escaped):
	#$Escaped.text = str(escaped)
	


func _on_timer_timeout():
	total_time_centseconds += 1
	var m = int(total_time_centseconds / 6000)
	var s = int(total_time_centseconds / 100 - (m * 60))
	var ms = total_time_centseconds - m * 6000 - s * 100
	%TimeLabel.text = '%02d:%02d:%02d' % [m, s, ms]
