extends BaseUi

signal tank
signal heli
signal fix_wing

signal on_joystick_input(output)
signal on_camera_control_input(event)

var events : Dictionary = {}
onready var virtual_joystick = $CanvasLayer/Control/virtual_joystick
onready var up = $CanvasLayer/Control/up
onready var down = $CanvasLayer/Control/down
onready var camera_control = $CanvasLayer/Control/camera_control

func _ready():
	_on_tank_pressed()
	
func hide_control():
	virtual_joystick.hide()
	up.hide()
	down.hide()
	camera_control.hide()
	
func _on_virtual_joystick_on_joystick_input(output):
	emit_signal("on_joystick_input", output)
	
func is_up_pressed():
	return up.is_pressed()
	
func is_down_pressed():
	return down.is_pressed()
	
func _on_fix_wing_pressed():
	hide_control()
	virtual_joystick.show()
	camera_control.show()
	emit_signal("fix_wing")
	
func _on_heli_pressed():
	hide_control()
	virtual_joystick.show()
	camera_control.show()
	up.show()
	down.show()
	emit_signal("heli")
	
func _on_tank_pressed():
	hide_control()
	virtual_joystick.show()
	camera_control.show()
	emit_signal("tank")
	



