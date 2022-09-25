extends BaseVTolUnit

export var turret_rotation_speed :float = 5.50
export var turret_elevation_speed :float = 5.25

onready var turret = $turret
onready var gun = $turret/gun
onready var aiming_reticle = $turret/gun/aiming_reticle
onready var firing_delay = $firing_delay

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func attack(_at :Vector3):
	.attack(_at)
	
	if firing_delay.is_stopped():
		var bullet = preload("res://entity/projectile/mg_bullet/mg_bullet.tscn").instance()
		add_child(bullet)
		bullet.translation = gun.global_transform.origin
		bullet.launch(aiming_reticle.global_transform.origin)
		firing_delay.start()
		
	
func _motion(delta):
	._motion(delta)
	turret.rotation.y = lerp_angle(turret.rotation.y, horizontal_rotation - rotation.y, turret_rotation_speed * 2 * delta)
	turret.rotation_degrees.y = clamp(turret.rotation_degrees.y  , -45, 45)
	
	gun.rotation.x = lerp_angle(gun.rotation.x, vertical_elevation - rotation.x, turret_elevation_speed * delta)
	gun.rotation_degrees.x = clamp(gun.rotation_degrees.x, -45, 0)
