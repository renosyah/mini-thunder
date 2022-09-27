extends Spatial
class_name RotatingCamera

export var vertical_rotation_speed :float = 15.0
export var horizontal_rotation_speed :float = 25.0
export var facing_direction :Vector2 = Vector2.ZERO

func get_horizontal_rotation() -> float:
	return rotation.y
	
func get_vertical_elevation() -> float:
	return rotation.x
	
func _process(delta):
	rotation_degrees.y += -facing_direction.x * horizontal_rotation_speed * delta
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
	rotation_degrees.x += facing_direction.y * vertical_rotation_speed * delta
	rotation_degrees.x = clamp(rotation_degrees.x, -60, 40)

