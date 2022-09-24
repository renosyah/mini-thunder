extends MarginContainer

export var joystick :NodePath
export var camera_deceleration = 5.0
var _facing_direction :Vector2 = Vector2.ZERO

onready var _joystick :VirtualJoystick = get_node(joystick)

func get_facing_direction() -> Vector2:
	return _facing_direction

func _process(delta):
	_facing_direction = lerp(_facing_direction, Vector2.ZERO, camera_deceleration * delta)

func _input(event : InputEvent):
	if not event is InputEventScreenDrag:
		return
		
	if event.index == _joystick.get_touch_index():
		return
		
	_facing_direction = event.relative
