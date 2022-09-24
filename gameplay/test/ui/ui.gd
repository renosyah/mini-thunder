extends BaseUi

signal on_joystick_input(output)
signal on_camera_control_input(event)

var events : Dictionary = {}
onready var up = $CanvasLayer/Control/up
onready var down = $CanvasLayer/Control/down
onready var camera_control = $CanvasLayer/Control/camera_control

func _on_virtual_joystick_on_joystick_input(output):
	emit_signal("on_joystick_input", output)
	
func is_up_pressed():
	return up.is_pressed()
	
func is_down_pressed():
	return down.is_pressed()
