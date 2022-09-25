extends ColorRect

var pressed :bool = false
onready var default_color = color

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event : InputEvent):
	if event is InputEventScreenTouch:
		if _is_point_inside_area(event.position):
			pressed = event.pressed
			color.a = 0.6
			get_viewport().set_input_as_handled()
		else:
			pressed = false
			
func _process(delta):
	if not pressed:
		color = default_color
	else:
		color.a = 0.6
		
func _is_point_inside_area(point: Vector2) -> bool:
	var x: bool = point.x >= rect_global_position.x and point.x <= rect_global_position.x + (rect_size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= rect_global_position.y and point.y <= rect_global_position.y + (rect_size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y
