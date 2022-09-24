extends Spatial
class_name RotatingCamera

export var vertical_inverted = false
export var facing_direction = Vector2.ZERO
export var camera_rotation_speed = 0.25

onready var _camera = $Camera

func get_horizontal_rotation() -> float:
	return rotation.y
	
func get_vertical_elevation() -> float:
	return rotation.x
	
func _process(delta):
	rotation_degrees.y += -facing_direction.x * camera_rotation_speed
	rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
	rotation_degrees.x += (-facing_direction.y if vertical_inverted else facing_direction.y) * camera_rotation_speed
	rotation_degrees.x = clamp(rotation_degrees.x, -60, 40)

