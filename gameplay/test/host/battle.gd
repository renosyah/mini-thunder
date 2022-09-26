extends BaseGameplay

var _unit :BaseUnit

var command_move_direction :Vector2
var command_facing_direction :Vector2
var command_climb_direction :float
var command_atack :bool

onready var training_helicopter :BaseVTolUnit = $training_helicopter
onready var training_tank :BaseGroundUnit = $training_tank
onready var training_aircraft :BaseFixedWingUnit = $training_aircraft

# Called when the node enters the scene tree for the first time.
func _ready():
	training_helicopter.set_network_master(Network.PLAYER_HOST_ID)
	training_tank.set_network_master(Network.PLAYER_HOST_ID)
	training_aircraft.set_network_master(Network.PLAYER_HOST_ID)
	
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
	_camera.facing_direction = _ui.camera_control.get_facing_direction()
	_camera.translation = _unit.translation
	_unit.facing_direction = Vector2(_camera.get_vertical_elevation(), _camera.get_horizontal_rotation())
	
	if _unit is BaseVTolUnit:
		_unit.climb_direction = 1 if _ui.is_up_pressed() else -1 if _ui.is_down_pressed() else 0
		
	if _unit is BaseGroundUnit:
		_unit.camera_basis = _camera.get_global_transform().basis
		
	if _unit is BaseFixedWingUnit:
		_unit.climb_direction = 1 if _ui.is_up_pressed() else -1 if _ui.is_down_pressed() else 0
		
	if _ui.is_fire_pressed():
		_unit.attack()
		
		
func on_joystick_input(output :Vector2):
	.on_joystick_input(output)
	_unit.move_direction = output
	
remote func _send_command(_to_unit :NodePath, _command : Dictionary):
	if not is_server():
		return
		
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
	
	
	
	
	
	
	
	
	
	
	
