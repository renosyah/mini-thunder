extends BaseUnit
class_name BaseFixedWingUnit

export var inverted :bool = true
export var trust_step_speed :float = 15.0
export var trust_min_speed :float = 5.0
export var trust_max_speed :float = 25.0
export var rotation_speed :float = 1.25
export var horizontal_rotation :float = 0.0
export var vertical_elevation :float = 0.0
export var input_response = 25.0

var climb_direction:float = 0.0

var _pitch_input:float = 0.0
var _roll_input:float = 0.0

func _ready():
	speed = 0.0
	gravity_multiplier = 2.0
	_gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)

func _direction_input() -> void:
	#._direction_input()
	_aim_direction = Vector3.ZERO
	var _aim: Basis = get_global_transform().basis
	_aim_direction = _aim.z * -1.0
	
func _motion(delta):
	#._motion(delta)
	_direction_input()
	
	rotation.x = lerp(rotation.x, 0.0, rotation_speed * delta)
	rotation.y = lerp_angle(rotation.y, horizontal_rotation, rotation_speed * delta)
	rotation.z = lerp(rotation.z, 0.0, rotation_speed * delta)
	speed += climb_direction * trust_step_speed * delta
	speed = clamp(speed, 0, trust_max_speed)
	
	if is_on_floor() and speed <= trust_min_speed:
		_snap = -get_floor_normal() - get_floor_velocity() * delta
		if _velocity.y < 0:
			_velocity.y = 0
			
	else:
		_snap = Vector3.ZERO
		
		if abs(speed) < 0.5:
			_velocity.y -= _gravity * delta
			
		else:
			_velocity.y -= transform.basis.z.y + move_direction.y * delta
		
	_accelerate(delta)
	_roll(delta)
	#_pitch_yaw(delta)
	
	_velocity = move_and_slide_with_snap(_velocity, _snap, _up_direction, _stop_on_slope, 4, _floor_max_angle)
	_velocity.y = lerp(_velocity.y, 0.0, 5 * delta)
	
func _roll(delta: float):
	if _snap != Vector3.ZERO:
		return
		
	_roll_input = lerp(_roll_input, -move_direction.x, input_response * delta)
	_pitch_input = lerp(_pitch_input, move_direction.y if inverted else -move_direction.y, input_response * delta)
	
	transform.basis = transform.basis.rotated(transform.basis.z, _roll_input * rotation_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.x, _pitch_input * rotation_speed * delta)
	transform.basis = transform.basis.orthonormalized()
	
func _pitch_yaw(delta: float) -> void:
	if _snap != Vector3.ZERO:
		return
		
	var v_amount = abs(vertical_elevation)
	var v_direction = sign(vertical_elevation)
	rotation_degrees.x = lerp(0, 60, v_amount) * v_direction
