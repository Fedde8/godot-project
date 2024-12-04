extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
		
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused

@onready var main = $"../"

func _ready():
	print("Main reference:", main)

func _on_resume_pressed():
	if main.has_method("pauseMenu"):
		print("Calling pauseMenu...")
		main.pauseMenu()
		self.hide()
	else:
		print("Error: 'pauseMenu' function not found in main")
