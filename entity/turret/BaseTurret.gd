extends MeshInstance
class_name BaseTurret

export var turret_rotation_speed :float = 5.50
export var turret_elevation_speed :float = 5.25
export var facing_direction :Vector2 = Vector2.ZERO

func get_projectile_spawn_point() -> Vector3:
	return Vector3.ZERO

func get_projectile_target_point() ->Vector3:
	return Vector3.ZERO
