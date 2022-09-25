extends BaseGameplay

var _unit :BaseUnit

onready var training_helicopter :BaseVTolUnit = $training_helicopter
onready var training_tank :BaseGroundUnit = $training_tank

# Called when the node enters the scene tree for the first time.
func _ready():
	_unit = training_tank
	_choose_tank()
	_ui.connect("tank", self, "_choose_tank")
	_ui.connect("heli", self, "_choose_heli")
	_ui.connect("fix_wing", self, "_choose_fix_wing")
	
func _choose_tank():
	_unit = training_tank
	_camera.rotation.y = _unit.rotation.y
	
func _choose_heli():
	_unit = training_helicopter
	_camera.rotation.y = _unit.rotation.y
	
func _choose_fix_wing():
	pass
	
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
	
