class_name Mainmenu
extends Control

# Declare variables for buttons and scenes
@onready var start_button = get_node("MarginContainer/HBoxContainer/VBoxContainer/Start_button") as Button
@onready var exit_button = get_node("MarginContainer/HBoxContainer/VBoxContainer/exit_button") as Button
@onready var start_level = preload(""class_name Mainmenu
extends Control

# Declare variables for buttons and scenes
@onready var start_button = get_node("MarginContainer/HBoxContainer/VBoxContainer/Start_button") as Button
@onready var exit_button = get_node("MarginContainer/HBoxContainer/VBoxContainer/exit_button") as Button
@onready var start_level = preload("res://node_2d.tscn";) as PackedScene

# Called when the node is ready
func _ready():
	# Connect the button signals to respective functions
	start_button.pressed.connect(on_start_pressed)
	exit_button.pressed.connect(on_exit_pressed)

# Handle the start button press
func on_start_pressed() -> void:
	# Change the scene to the start level
	get_tree().change_scene_to_packed(start_level)

# Handle the exit button press
func on_exit_pressed() -> void:
	# Quit the game
	get_tree().quit()"";) as PackedScene

# Called when the node is ready
func _ready():
	# Connect the button signals to respective functions
	start_button.pressed.connect(on_start_pressed)
	exit_button.pressed.connect(on_exit_pressed)

# Handle the start button press
func on_start_pressed() -> void:
	# Change the scene to the start level
	get_tree().change_scene_to_packed(start_level)

# Handle the exit button press
func on_exit_pressed() -> void:
	# Quit the game
	get_tree().quit()
