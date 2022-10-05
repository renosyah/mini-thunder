extends BaseGroundUnit

onready var animation_state = $pivot/AnimationTree.get("parameters/playback")
onready var firing_delay = $firing_delay

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _set_puppet_moving_state(_val : int):
	._set_puppet_moving_state(_val)
	match _moving_state:
		IDDLE:
			animation_state.travel("Idle")
		MOVING:
			animation_state.travel("Run")
		NONE:
			pass
	
remotesync func _attack():
	animation_state.travel("Attack")
	
func attack():
	#.attack()
	
	if not _is_master():
		return
		
	if firing_delay.is_stopped():
		rpc_unreliable("_attack")
		firing_delay.start()
		
