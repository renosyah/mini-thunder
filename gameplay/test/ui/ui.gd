extends BaseUi

signal fox
signal tank
signal heli
signal fix_wing

var events : Dictionary = {}
onready var virtual_joystick = $CanvasLayer/Control/virtual_joystick
onready var up = $CanvasLayer/Control/up
onready var down = $CanvasLayer/Control/down
onready var camera_control = $CanvasLayer/Control/camera_control
onready var fire = $CanvasLayer/Control/fire
onready var jump = $CanvasLayer/Control/jump

func _ready():
	_on_tank_pressed()
	
func hide_control():
	virtual_joystick.hide()
	up.hide()
	down.hide()
	camera_control.hide()
	
func is_up_pressed():
	return up.pressed
	
func is_down_pressed():
	return down.pressed
	
func is_fire_pressed():
	return fire.pressed
	
func is_jump_pressed():
	return jump.pressed
	
func joystick_move_direction() -> Vector2:
	return virtual_joystick.get_output()
	
func camera_facing_direction() -> Vector2:
	return camera_control.get_facing_direction()
	
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
	
func _on_fox_pressed():
	hide_control()
	virtual_joystick.show()
	camera_control.show()
	emit_signal("fox")
