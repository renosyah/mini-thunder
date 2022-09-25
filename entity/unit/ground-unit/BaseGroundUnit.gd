extends BaseUnit
class_name BaseGroundUnit

export var horizontal_rotation :float = 0.0
export var vertical_elevation :float = 0.0
export var rotation_speed :float = 1.25

func _ready():
	gravity_multiplier = 2.0
	_gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)

func _direction_input() -> void:
	#._direction_input()
	_aim_direction = Vector3.ZERO
	var _aim: Basis = get_global_transform().basis
	_aim_direction = _aim.z * move_direction.y
	
func _motion(delta):
	#._motion(delta)
	_direction_input()
	
	if is_on_floor():
		_snap = -get_floor_normal() - get_floor_velocity() * delta
		
		if move_direction.y >= 0.0:
			rotate_y(move_direction.x * rotation_speed * delta)
		else:
			rotate_y(-move_direction.x * rotation_speed * delta)
			
		if _velocity.y < 0:
			_velocity.y = 0
	else:
		if _snap != Vector3.ZERO and _velocity.y != 0:
			_velocity.y = 0
			
		_snap = Vector3.ZERO
		_velocity.y -= _gravity * delta
		
	_accelerate(delta)
	_velocity = move_and_slide_with_snap(_velocity, _snap, _up_direction, _stop_on_slope, 4, _floor_max_angle)
	
