extends BaseFixedWingUnit

export var turret_rotation_speed :float = 5.50
export var turret_elevation_speed :float = 5.25

onready var cpu_particles = $CPUParticles
onready var firing_delay = $firing_delay
onready var gun = $turret/gun
onready var aiming_reticle = $turret/gun/aiming_reticle
onready var turret = $turret

func _motion(delta):
	._motion(delta)
	cpu_particles.emitting = speed > trust_min_speed

	turret.rotation.y = lerp_angle(turret.rotation.y, horizontal_rotation - rotation.y, turret_rotation_speed * 2 * delta)
	turret.rotation_degrees.y = clamp(turret.rotation_degrees.y  , -45, 45)
	
	gun.rotation.x = lerp_angle(gun.rotation.x, vertical_elevation - rotation.x, turret_elevation_speed * delta)
	gun.rotation_degrees.x = clamp(gun.rotation_degrees.x, -45, 0)
	
	
func attack(_at :Vector3):
	.attack(_at)
	
	if firing_delay.is_stopped():
		var bullet = preload("res://entity/projectile/med_caliber/med_caliber.tscn").instance()
		bullet.speed = 40
		add_child(bullet)
		bullet.translation = gun.global_transform.origin
		bullet.launch(aiming_reticle.global_transform.origin)
		firing_delay.start()
		
	
