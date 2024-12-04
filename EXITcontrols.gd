extends Button

func _on_button_pressed():
	# Laad de nieuwe scène
	var next_scene = preload("res://menu.tscn")  # Pad naar je andere scène
	get_tree().change_scene_to(next_scene)



func _on_pressed() -> void:
	pass # Replace with function body.
