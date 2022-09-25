extends BaseGroundUnit

export var turret_rotation_speed :float = 5.50
export var turret_elevation_speed :float = 5.25

onready var turret = $turret
onready var gun = $turret/gun
onready var aiming_reticle = $turret/gun/aiming_reticle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _motion(delta):
	._motion(delta)
	turret.rotation.y = lerp_angle(turret.rotation.y, horizontal_rotation - rotation.y, turret_rotation_speed * 2 * delta)
	
	gun.rotation.x = lerp_angle(gun.rotation.x, vertical_elevation - rotation.x, turret_elevation_speed * delta)
	gun.rotation_degrees.x = clamp(gun.rotation_degrees.x, -5, 15)
