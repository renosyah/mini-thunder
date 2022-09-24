extends BaseGameplay

onready var _vtol_test = $vtol_test

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _process(delta):
	_camera.facing_direction = _ui.camera_control.get_facing_direction()
	_camera.translation = _vtol_test.translation
	_vtol_test.climb_direction = 1 if _ui.is_up_pressed() else -1 if _ui.is_down_pressed() else 0
	_vtol_test.horizontal_rotation = _camera.get_horizontal_rotation()
	_vtol_test.vertical_elevation  = _camera.get_vertical_elevation()
	
func on_joystick_input(output :Vector2):
	.on_joystick_input(output)
	_vtol_test.move_direction = output
	
