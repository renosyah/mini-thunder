extends BaseFixedWingUnit

onready var cpu_particles = $CPUParticles
onready var firing_delay = $firing_delay
onready var position_3d = $pivot/Position3D
onready var aiming_reticle = $aiming_reticle

func _motion(delta):
	._motion(delta)
	cpu_particles.emitting = speed > trust_min_speed
	
func attack(_at :Vector3):
	.attack(_at)
	
	if firing_delay.is_stopped():
		var bullet = preload("res://entity/projectile/med_caliber/med_caliber.tscn").instance()
		bullet.speed = 40
		add_child(bullet)
		bullet.translation = position_3d.global_transform.origin
		bullet.launch(aiming_reticle.global_transform.origin)
		firing_delay.start()
		
	
