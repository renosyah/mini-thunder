extends BaseTurret

onready var gun = $gun
onready var projectile_spawn_point = $gun/Position3D
onready var projectile_target_point = $gun/aiming_reticle

func get_projectile_spawn_point() -> Vector3:
	return projectile_spawn_point.global_transform.origin

func get_projectile_target_point() ->Vector3:
	return projectile_target_point.global_transform.origin

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation.y = lerp_angle(rotation.y, facing_direction.y - get_parent().rotation.y, turret_rotation_speed * 2 * delta)
	
	gun.rotation.x = lerp_angle(gun.rotation.x,facing_direction.x - get_parent().rotation.x, turret_elevation_speed * delta)
	gun.rotation_degrees.x = clamp(gun.rotation_degrees.x, -5, 15)

