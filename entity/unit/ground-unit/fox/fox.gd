extends BaseGroundUnit

onready var animation_state = $pivot/AnimationTree.get("parameters/playback")
onready var firing_delay = $firing_delay

var node_not_move = ["Attack", "Jump", "Fall","ToucheGround"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
remotesync func _attack():
	animation_state.travel("Attack")
	
remotesync func _jump():
	animation_state.travel("ToucheGround")
	
func attack():
	#.attack()
	
	if not _is_master():
		return
		
	if firing_delay.is_stopped():
		rpc_unreliable("_attack")
		firing_delay.start()
		
func jump():
	if not _is_master():
		return
		
	if is_on_floor():
		_snap = Vector3.ZERO
		translation.y += 0.55
		_velocity.y = 35.0
		rpc_unreliable("_jump")
	
func _on_animation_checker_timeout():
	if move_direction != Vector2.ZERO:
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
