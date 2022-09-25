extends BaseUnit
class_name BaseFixedWingUnit

export var rotation_speed :float = 1.25
export var horizontal_rotation :float = 0.0
export var vertical_elevation :float = 0.0
export var input_response = 25.0

var _pitch_input:float = 0.0
var _roll_input:float = 0.0

func _direction_input() -> void:
	#._direction_input()
	_aim_direction = Vector3.ZERO
	var _aim: Basis = get_global_transform().basis
	_aim_direction = _aim.z * -1.0
	
func _motion(delta):
	#._motion(delta)
	_direction_input()
	
	speed -= move_direction.y * 15 * delta
	speed = clamp(speed, 5, 65)
	
	rotation.x = lerp(rotation.x, 0.0, rotation_speed * delta)
	rotation.z = lerp(rotation.z, 0.0, rotation_speed * delta)
	
	_snap = Vector3.ZERO
	rotation.y = lerp_angle(rotation.y, horizontal_rotation, rotation_speed * delta)
	_velocity.y -= transform.basis.z.y + vertical_elevation * delta
	
	_accelerate(delta)
	roll(delta)
	pitch_yaw(delta)
	
	_velocity = move_and_slide_with_snap(_velocity, _snap, _up_direction, _stop_on_slope, 4, _floor_max_angle)
	_velocity.y = lerp(_velocity.y, 0.0, 5 * delta)
	
	
func roll(delta: float):
	_roll_input = lerp(_roll_input, -move_direction.x, input_response * delta)
		
	transform.basis = transform.basis.rotated(transform.basis.z, _roll_input * rotation_speed * delta)
	transform.basis = transform.basis.orthonormalized()
	
func pitch_yaw(delta: float) -> void:
	var v_amount = abs(vertical_elevation)
	var v_direction = sign(vertical_elevation)
	rotation_degrees.x = lerp(0, 60, v_amount) * v_direction
