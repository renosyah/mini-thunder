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
	
	init_client()
	
func _choose_tank():
	_unit = training_tank
	_camera.rotation.y = _unit.rotation.y
	
func _choose_heli():
	_unit = training_helicopter
	_camera.rotation.y = _unit.rotation.y
	
func _choose_fix_wing():
	_unit = training_aircraft
	_camera.rotation.y = _unit.rotation.y
	
func on_client_pool_network_request():
	if not is_network_on():
		return
		
	rpc_unreliable_id(Network.PLAYER_HOST_ID, "_send_command", _unit.get_path(), {
		"command_move_direction":command_move_direction,
		"command_facing_direction":command_facing_direction,
		"command_climb_direction":command_climb_direction,
		"command_atack":command_atack,
		"command_camera_basis": _camera.get_global_transform().basis,
	})
	
func _process(delta):
	_camera.facing_direction = _ui.camera_control.get_facing_direction()
	_camera.translation = _unit.translation
	command_facing_direction = Vector2(_camera.get_vertical_elevation(), _camera.get_horizontal_rotation())
	command_climb_direction = 1 if _ui.is_up_pressed() else -1 if _ui.is_down_pressed() else 0
	command_atack = _ui.is_fire_pressed()
	
func on_joystick_input(output :Vector2):
	.on_joystick_input(output)
	command_move_direction = output
	
