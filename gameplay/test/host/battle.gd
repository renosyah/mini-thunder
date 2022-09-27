extends BaseGameplay

var _unit :BaseUnit

onready var training_helicopter :BaseVTolUnit = $training_helicopter
onready var training_tank :BaseGroundUnit = $training_tank
onready var training_aircraft :BaseFixedWingUnit = $training_aircraft

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
	_unit = training_aircraft
	_camera.rotation.y = _unit.rotation.y
	
func _process(delta):
	_camera.facing_direction = _ui.camera_facing_direction()
	_camera.translation = _unit.translation
	var command :Dictionary = {
		"command_move_direction": _ui.joystick_move_direction(),
		"command_facing_direction":_camera.get_facing_direction(),
		"command_climb_direction": 1 if _ui.is_up_pressed() else -1 if _ui.is_down_pressed() else 0,
		"command_atack": _ui.is_fire_pressed(),
		"command_camera_basis": _camera.get_camera_basis(),
	}
	_send_command(_unit.get_path(), command)
	
remote func _send_command(_to_unit :NodePath, _command : Dictionary):
	var to_unit = get_node_or_null(_to_unit)
	if not is_instance_valid(to_unit):
		return
		
	if to_unit is BaseVTolUnit:
		to_unit.climb_direction = _command["command_climb_direction"]
		
	if to_unit is BaseGroundUnit:
		to_unit.camera_basis = _command["command_camera_basis"]
		
	if to_unit is BaseFixedWingUnit:
		to_unit.climb_direction = _command["command_climb_direction"]
		
	to_unit.move_direction = _command["command_move_direction"]
	to_unit.facing_direction = _command["command_facing_direction"]
	if _command["command_atack"]:
		to_unit.attack()
	
	
	
	
	
	
	
	
	
	
	
