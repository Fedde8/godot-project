extends Control

@onready var main = $"../" 
@onready var pause_menu = $"../PauseMenu" 
var paused = false
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		toggle_pause()
func toggle_pause():
	paused = !paused
	if paused:
		Engine.time_scale = 0  
		pause_menu.show()      
	else:
		Engine.time_scale = 1  
		pause_menu.hide()      

func _on_resume_pressed():
	toggle_pause()  

func _on_quit_game_pressed():
	get_tree().quit()
