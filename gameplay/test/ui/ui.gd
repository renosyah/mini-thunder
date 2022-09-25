extends BaseUi

signal tank
signal heli
signal fix_wing

signal engine_status(is_on)

signal on_joystick_input(output)
signal on_camera_control_input(event)

var events : Dictionary = {}
onready var virtual_joystick = $CanvasLayer/Control/virtual_joystick
onready var up = $CanvasLayer/Control/up
onready var down = $CanvasLayer/Control/down
onready var camera_control = $CanvasLayer/Control/camera_control
onready var fire = $CanvasLayer/Control/fire

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
	return up.pressed
	
func is_down_pressed():
	return down.pressed
	
func is_fire_pressed():
	return fire.pressed
	
func _on_fix_wing_pressed():
	hide_control()
	virtual_joystick.show()
	camera_control.show()
	up.show()
	down.show()
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
	
