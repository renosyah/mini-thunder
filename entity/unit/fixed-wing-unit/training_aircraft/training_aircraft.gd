extends BaseFixedWingUnit
onready var cpu_particles = $CPUParticles

func _motion(delta):
	._motion(delta)
	cpu_particles.emitting = speed > trust_min_speed
