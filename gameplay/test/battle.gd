extends BaseGameplay

var _unit :BaseUnit

onready var training_helicopter = $training_helicopter
onready var training_tank = $training_tank

# Called when the node enters the scene tree for the first time.
func _ready():
	_unit = training_tank
	
func _process(delta):
	_camera.facing_direction = _ui.camera_control.get_facing_direction()
	_camera.translation = _unit.translation
	
	if _unit is BaseVTolUnit:
		_unit.climb_direction = 1 if _ui.is_up_pressed() else -1 if _ui.is_down_pressed() else 0
		_unit.horizontal_rotation = _camera.get_horizontal_rotation()
		_unit.vertical_elevation  = _camera.get_vertical_elevation()
		
	if _unit is BaseGroundUnit:
		_unit.horizontal_rotation = _camera.get_horizontal_rotation()
		_unit.vertical_elevation  = _camera.get_vertical_elevation()
		
func on_joystick_input(output :Vector2):
	.on_joystick_input(output)
	_unit.move_direction = output
	
