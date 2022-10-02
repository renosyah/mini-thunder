extends BaseGroundUnit

onready var turret :BaseTurret = $turret
onready var firing_delay :Timer = $firing_delay

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
remotesync func _attack():
	var bullet = preload("res://entity/projectile/high_caliber/high_caliber.tscn").instance()
	bullet.speed = 40
	add_child(bullet)
	bullet.translation = turret.get_projectile_spawn_point()
	bullet.launch(turret.get_projectile_target_point())
	
func attack():
	#.attack()
	
	if not _is_master():
		return
		
	if firing_delay.is_stopped():
		rpc_unreliable("_attack")
		firing_delay.start()
		
	
func moving(delta):
	.moving(delta)
	turret.facing_direction = facing_direction
