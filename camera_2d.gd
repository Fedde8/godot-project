extends Camera2D

@export var camera_speed: float = 200.0        
@export var zoom_speed: float = 0.0001             
@export var min_zoom: float = 0.05              
@export var max_zoom: float = 5.0               
@export var mouse_edge_scroll_speed: float = 300.0  
@export var edge_margin: int = 20               
var paused = false
func _process(delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1


	position += direction.normalized() * (camera_speed if direction != Vector2.ZERO else mouse_edge_scroll_speed) * delta

	if Input.is_action_pressed("zoom_in"):
		zoom *= 1.01 
	elif Input.is_action_pressed("zoom_out"):
		zoom *= 0.99  
	
	zoom.x = clamp(zoom.x,1.5, max_zoom)
	zoom.y = clamp(zoom.y, 1.5, max_zoom)

	print("Current zoom:", zoom)
