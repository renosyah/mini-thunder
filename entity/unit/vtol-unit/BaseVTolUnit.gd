extends BaseUnit
class_name BaseVTolUnit

export var climb_speed = 25.0
export var rotation_speed :float = 2.25
export var input_response = 25.0

var climb_direction:float = 0.0

var _pitch_input:float = 0.0
var _roll_input:float = 0.0
var _wobling :Vector2 = Vector2.ZERO
var _wobling_timer :Timer

func _ready():
	_wobling_timer = Timer.new()
	_wobling_timer.wait_time = 2.2
	_wobling_timer.one_shot = false
	_wobling_timer.autostart = true
	_wobling_timer.connect("timeout", self , "_wobling_timer_timeout")
	add_child(_wobling_timer)
	
func _wobling_timer_timeout():
	_wobling = Vector2(rand_range(-0.12, 0.12), rand_range(-0.11, 0.11))
	
func master_moving(delta):
	.master_moving(delta)
	_direction_input()
	
	rotation.x = lerp(rotation.x, 0.0, rotation_speed * delta)
	rotation.z = lerp(rotation.z, 0.0, rotation_speed * delta)
	
	if is_on_floor() and climb_direction <= 0.0:
		_snap = -get_floor_normal() - get_floor_velocity() * delta
		if _velocity.y < 0:
			_velocity.y = 0
	else:
		if _snap != Vector3.ZERO and _velocity.y != 0:
			_velocity.y = 0
			
		_snap = Vector3.ZERO
		rotation.y = lerp_angle(rotation.y, facing_direction.y, rotation_speed * delta)
		
		_accelerate(delta)
		_velocity.y += climb_direction * climb_speed * delta
		roll_pitch(delta)
		
	_velocity = move_and_slide_with_snap(_velocity, _snap, _up_direction, _stop_on_slope, 4, _floor_max_angle)
	_velocity.y = lerp(_velocity.y, 0.0, 5 * delta)
	
func puppet_moving(delta):
	.puppet_moving(delta)
	
func roll_pitch(delta: float):
	if is_equal_approx(_velocity.length(), 0.0):
		_pitch_input = lerp(_pitch_input, _wobling.y, 1 * delta)
		_roll_input = lerp(_roll_input, -_wobling.x , 1 * delta)
	else:
		_pitch_input = lerp(_pitch_input, move_direction.y, input_response * delta)
		_roll_input = lerp(_roll_input, -move_direction.x , input_response * delta)
		
	transform.basis = transform.basis.rotated(transform.basis.z, _roll_input * rotation_speed * delta)
	rotation_degrees.z = clamp(rotation_degrees.z, -35, 35)
	
	transform.basis = transform.basis.rotated(transform.basis.x, _pitch_input * rotation_speed * delta)
	rotation_degrees.x = clamp(rotation_degrees.x, -35, 35)
	
	transform.basis = transform.basis.orthonormalized()
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
