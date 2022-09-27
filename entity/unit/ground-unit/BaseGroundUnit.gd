extends BaseUnit
class_name BaseGroundUnit

var camera_basis :Basis
export var rotation_speed :float = 6.25

func _ready() -> void:
	camera_basis = transform.basis
	gravity_multiplier = 2.0
	_gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)

func _direction_input() -> void:
	# full override
	# dont remove comment
	#._direction_input()
	_aim_direction = Vector3.ZERO
	_aim_direction = camera_basis.z * move_direction.y + camera_basis.x * move_direction.x
	
func master_moving(delta :float) -> void:
	# full override
	# dont remove comment
	#.master_moving(delta)
	_direction_input()
	
	if is_on_floor():
		_snap = -get_floor_normal() - get_floor_velocity() * delta
		if _aim_direction != Vector3.ZERO and _velocity + translation != translation:
			_transform_turning(_velocity + translation, delta)
			
	else:
		_snap = Vector3.ZERO
		_velocity.y -= _gravity * delta
		
	_accelerate(delta)
	_velocity = move_and_slide_with_snap(_velocity, _snap, _up_direction, _stop_on_slope, 4, _floor_max_angle)
	_velocity.y = lerp(_velocity.y, 0.0, 5 * delta)
	
############################################################
# utils
func _transform_turning(direction :Vector3, delta :float) -> void:
	var new_transform :Transform = transform.looking_at(direction, Vector3.UP)
	transform = transform.interpolate_with(new_transform, rotation_speed * delta)


