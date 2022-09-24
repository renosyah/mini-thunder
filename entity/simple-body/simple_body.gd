extends BaseEntity

export var gravity_multiplier :float = 1.75
export(float, 0.0, 1.0, 0.05) var air_control :float = 0.3
export var direction :Vector2 = Vector2.ZERO
export var jump :bool = false
export var rotation_y :float = 0.0
export var jump_height :float = 10.0

var speed :float = 4.0
var acceleration :float = 2.0
var deceleration :float = 6.0
var velocity :Vector3 = Vector3.ZERO
var snap :Vector3 = Vector3.ZERO
var up_direction :Vector3 = Vector3.UP
var stop_on_slope :bool = true
var aim_direction :Vector3 = Vector3()

onready var floor_max_angle: float = deg2rad(45.0)
onready var gravity = (ProjectSettings.get_setting("physics/3d/default_gravity") * gravity_multiplier)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func moving(delta):
	.moving(delta)
	
	rotation.y = lerp_angle(rotation.y, rotation_y, 5 * delta)
	
	direction_input()
	
	if is_on_floor():
		snap = -get_floor_normal() - get_floor_velocity() * delta
		if velocity.y < 0:
			velocity.y = 0
			
		if Input.is_action_just_pressed("test_jump"):
			snap = Vector3.ZERO
			velocity.y = jump_height
			
	else:
		if snap != Vector3.ZERO and velocity.y != 0:
			velocity.y = 0
			
		snap = Vector3.ZERO
		velocity.y -= gravity * delta
		
	accelerate(delta)
	velocity = move_and_slide_with_snap(velocity, snap, up_direction, stop_on_slope, 4, floor_max_angle)
	
func direction_input() -> void:
	aim_direction = Vector3.ZERO
	var aim: Basis = get_global_transform().basis
	aim_direction = aim.z * direction.y + aim.x * direction.x
	
func accelerate(delta: float) -> void:
	var temp_vel = velocity
	temp_vel.y = 0
	
	var temp_accel: float
	var target: Vector3 = aim_direction * speed
	
	if aim_direction.dot(temp_vel) > 0:
		temp_accel = acceleration
	else:
		temp_accel = deceleration
	
	if not is_on_floor():
		temp_accel *= air_control
	
	temp_vel = temp_vel.linear_interpolate(target, temp_accel * delta)
	
	velocity.x = temp_vel.x
	velocity.z = temp_vel.z
	
