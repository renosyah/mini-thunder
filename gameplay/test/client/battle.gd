extends BaseGameplay

var _unit :BaseUnit

onready var fox :BaseGroundUnit = $fox
onready var training_helicopter :BaseVTolUnit = $training_helicopter
onready var training_tank :BaseGroundUnit = $training_tank
onready var training_aircraft :BaseFixedWingUnit = $training_aircraft

# Called when the node enters the scene tree for the first time.
func _ready():
	_unit = training_tank
	_choose_tank()
	_ui.connect("fox", self, "_choose_fox")
	_ui.connect("tank", self, "_choose_tank")
	_ui.connect("heli", self, "_choose_heli")
	_ui.connect("fix_wing", self, "_choose_fix_wing")
	
	init_client()
	
func _choose_fox():
	_unit = fox
	_camera.rotation.y = _unit.rotation.y
	
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
	
func on_client_pool_network_request():
	if not is_network_on():
		return
		
	var command :Dictionary = {
		"command_move_direction": _ui.joystick_move_direction(),
		"command_facing_direction": _camera.get_facing_direction(),
		"command_climb_direction": 1 if _ui.is_up_pressed() else -1 if _ui.is_down_pressed() else 0,
		"command_atack": _ui.is_fire_pressed(),
		"command_camera_basis": _camera.get_camera_basis(),
	}
	rpc_unreliable_id(Network.PLAYER_HOST_ID, "_send_command", _unit.get_path(), command)
	
