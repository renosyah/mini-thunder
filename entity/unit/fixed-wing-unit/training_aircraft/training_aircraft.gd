extends BaseFixedWingUnit

export var turret_rotation_speed :float = 5.50
export var turret_elevation_speed :float = 5.25

onready var cpu_particles = $CPUParticles
onready var firing_delay = $firing_delay
onready var gun = $turret/gun
onready var aiming_reticle = $turret/gun/aiming_reticle
onready var turret = $turret

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
remotesync func _attack():
	var bullet = preload("res://entity/projectile/med_caliber/med_caliber.tscn").instance()
	bullet.speed = 40
	add_child(bullet)
	bullet.translation = gun.global_transform.origin
	bullet.launch(aiming_reticle.global_transform.origin)
	
func attack():
	#.attack()
	
	if not _is_master():
		return
		
	if firing_delay.is_stopped():
		rpc_unreliable("_attack")
		firing_delay.start()
		
func moving(delta):
	.moving(delta)
	cpu_particles.emitting = speed > trust_min_speed

	turret.rotation.y = lerp_angle(turret.rotation.y, facing_direction.y - rotation.y, turret_rotation_speed * 2 * delta)
	turret.rotation_degrees.y = clamp(turret.rotation_degrees.y  , -45, 45)
	
	gun.rotation.x = lerp_angle(gun.rotation.x, facing_direction.x - rotation.x, turret_elevation_speed * delta)
	gun.rotation_degrees.x = clamp(gun.rotation_degrees.x, -45, 0)
