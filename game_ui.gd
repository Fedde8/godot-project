extends Control

const HOUSE_COST_A = 50
const HOUSE_A_MONEY_PER_SECOND = 0.5
const HOUSE_A_FOOD_PER_SECOND = -0.2

const HOUSE_COST_B = 30
const HOUSE_B_MONEY_PER_SECOND = -0.3
const HOUSE_B_FOOD_PER_SECOND = 0.5

const HOUSE_COST_C = 100
const HOUSE_C_POINTS_PER_SECOND = 0.125
const HOUSE_C_MONEY_PER_SECOND = 0.0
const HOUSE_C_FOOD_PER_SECOND = 0.0

var selected_house_scene = preload("res://icon.tscn")
var house_b_scene = preload("res://house_b.tscn")
var house_c_scene = preload("res://house_c.tscn")

var player_money = 150
var player_food = 50
var player_points = 0

var is_dragging = false
var dragged_instance = null

var placed_houses = []

@onready var house_a_button = $HouseAButton
@onready var house_b_button = $HouseBButton
@onready var house_c_button = $HouseCButton
@onready var draggable_icon = $Panel/DraggableIcon
@onready var money_label = $MoneyLabel
@onready var food_label = $FoodLabel
@onready var points_label = $PointsLabel
@onready var world_node = get_node("/root/WorldNode")

func _ready():
	house_a_button.pressed.connect(_on_HouseAButton_pressed)
	house_b_button.pressed.connect(_on_HouseBButton_pressed)
	house_c_button.pressed.connect(_on_HouseCButton_pressed)
	draggable_icon.pressed.connect(_on_draggable_icon_pressed)
	update_ui_labels()

func update_ui_labels():
	money_label.text = "Money: %d" % player_money
	food_label.text = "Food: %d" % player_food
	points_label.text = "Points: %d" % player_points

func _on_HouseAButton_pressed():
	selected_house_scene = preload("res://icon.tscn")

func _on_HouseBButton_pressed():
	selected_house_scene = preload("res://house_b.tscn")

func _on_HouseCButton_pressed():
	selected_house_scene = preload("res://house_c.tscn")

func _on_draggable_icon_pressed():
	if not selected_house_scene:
		return

	var house_cost = get_selected_house_cost()
	if player_money >= house_cost:
		is_dragging = true
		dragged_instance = selected_house_scene.instantiate()
		world_node.add_child(dragged_instance)
		var mouse_pos = get_viewport().get_mouse_position()
		var instance_size = dragged_instance.get_rect().size if dragged_instance.has_method("get_rect") else Vector2()
		dragged_instance.position = mouse_pos - instance_size / 2

func _process(delta):
	if is_dragging and dragged_instance:
		var mouse_pos = get_viewport().get_mouse_position()
		var instance_size = dragged_instance.get_rect().size if dragged_instance.has_method("get_rect") else Vector2()
		dragged_instance.position = mouse_pos - instance_size / 2

	for house_data in placed_houses:
		house_data["timer"] += delta
		if house_data["timer"] >= 1.0:
			player_money += house_data["money_per_second"]
			player_food += house_data["food_per_second"]
			player_points += house_data["points_per_second"]
			house_data["timer"] = 0.0
			update_ui_labels()

	if player_food < 0:
		get_tree().change_scene_to_file("res://Game_over.tscn")

func _input(event):
	if event is InputEventMouseButton:
		# Left-click behavior
		if event.button_index == MOUSE_BUTTON_LEFT and is_dragging and event.pressed:
			is_dragging = false
			var mouse_pos = get_viewport().get_mouse_position()
			var instance_size = dragged_instance.get_rect().size if dragged_instance.has_method("get_rect") else Vector2()
			dragged_instance.position = mouse_pos - instance_size / 2

			if can_place_house(dragged_instance):
				place_house()
			else:
				dragged_instance.queue_free()

			dragged_instance = null

		# Right-click behavior
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			selected_house_scene = null
			if is_dragging and dragged_instance:
				dragged_instance.queue_free()
				dragged_instance = null
			is_dragging = false

func can_place_house(instance):
	var dragged_area = instance.get_node("Area2D")
	if dragged_area:
		var dragged_collision = dragged_area.get_node("CollisionShape2D")
		if not dragged_collision:
			return false

		for placed_house in placed_houses:
			var placed_area = placed_house["house"].get_node("Area2D")
			var placed_collision = placed_area.get_node("CollisionShape2D")
			if dragged_collision.shape and placed_collision.shape:
				var dragged_shape = dragged_collision.shape
				var placed_shape = placed_collision.shape
				if dragged_shape.collide_with_shape(placed_shape, Transform2D(), Transform2D()):
					return false
	return true

func place_house():
	var house_cost = get_selected_house_cost()
	player_money -= house_cost
	update_ui_labels()
	start_generating_resources(dragged_instance)
	placed_houses.append({
		"house": dragged_instance,
		"money_per_second": get_selected_house_money_per_second(),
		"food_per_second": get_selected_house_food_per_second(),
		"points_per_second": get_selected_house_points_per_second(),
		"timer": 0.0
	})
	is_dragging = false
	dragged_instance = null

func start_generating_resources(house_instance):
	placed_houses.append({
		"house": house_instance,
		"money_per_second": get_selected_house_money_per_second(),
		"food_per_second": get_selected_house_food_per_second(),
		"points_per_second": get_selected_house_points_per_second(),
		"timer": 0.0
	})

func get_selected_house_cost():
	if selected_house_scene == preload("res://icon.tscn"):
		return HOUSE_COST_A
	elif selected_house_scene == preload("res://house_b.tscn"):
		return HOUSE_COST_B
	elif selected_house_scene == preload("res://house_c.tscn"):
		return HOUSE_COST_C
	return 0

func get_selected_house_money_per_second():
	if selected_house_scene == preload("res://icon.tscn"):
		return HOUSE_A_MONEY_PER_SECOND
	elif selected_house_scene == preload("res://house_b.tscn"):
		return HOUSE_B_MONEY_PER_SECOND
	elif selected_house_scene == preload("res://house_c.tscn"):
		return HOUSE_C_MONEY_PER_SECOND
	return 0

func get_selected_house_food_per_second():
	if selected_house_scene == preload("res://icon.tscn"):
		return HOUSE_A_FOOD_PER_SECOND
	elif selected_house_scene == preload("res://house_b.tscn"):
		return HOUSE_B_FOOD_PER_SECOND
	elif selected_house_scene == preload("res://house_c.tscn"):
		return HOUSE_C_FOOD_PER_SECOND
	return 0

func get_selected_house_points_per_second():
	if selected_house_scene == preload("res://house_c.tscn"):
		return HOUSE_C_POINTS_PER_SECOND
	return 0
