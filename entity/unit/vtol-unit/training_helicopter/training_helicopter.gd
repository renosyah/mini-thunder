extends BaseVTolUnit

onready var firing_delay = $firing_delay
onready var turret = $turret

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
remotesync func _attack():
	var bullet = preload("res://entity/projectile/mg_bullet/mg_bullet.tscn").instance()
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
