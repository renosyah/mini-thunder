extends BaseEntity
class_name BaseUnit

export var gravity_multiplier :float = 0.075
export var move_direction :Vector2 = Vector2.ZERO
export var facing_direction :Vector2 = Vector2.ZERO

export var speed :float = 4.0
export var acceleration :float = 2.0
export var deceleration :float = 6.0

var _velocity :Vector3 = Vector3.ZERO
var _snap :Vector3 = Vector3.ZERO
var _up_direction :Vector3 = Vector3.UP
var _stop_on_slope :bool = true
var _aim_direction :Vector3 = Vector3()
onready var _gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)

onready var _floor_max_angle: float = deg2rad(45.0)

# unsing moving func 
# for testing only
func moving(delta):
	.moving(delta)
	_motion(delta)
	
func _motion(delta):
	_direction_input()
	_accelerate(delta)
	_velocity = move_and_slide_with_snap(_velocity, _snap, _up_direction, _stop_on_slope, 4, _floor_max_angle)
	
func _direction_input() -> void:
	_aim_direction = Vector3.ZERO
	var _aim: Basis = get_global_transform().basis
	_aim_direction = _aim.z * move_direction.y + _aim.x * move_direction.x
	
func _accelerate(delta: float) -> void:
	var temp_vel = _velocity
	temp_vel.y = 0.0
	
	var temp_accel: float
	var target: Vector3 = _aim_direction * speed
	
	if _aim_direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	_velocity.x = temp_vel.x
	_velocity.z = temp_vel.z
	
