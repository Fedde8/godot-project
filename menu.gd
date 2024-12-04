extends Control


func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Werkend Camera.tscn")


func _on_settings_2_pressed() -> void:
	get_tree().change_scene_to_file("res://control.tscn")


func _on_exit_3_pressed() -> void:
	get_tree().quit()
