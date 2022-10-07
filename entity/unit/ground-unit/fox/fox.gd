extends BaseGroundUnit

onready var animation_state = $pivot/AnimationTree.get("parameters/playback")
onready var firing_delay = $firing_delay

var node_not_move = ["Attack"]
var is_jump = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
remotesync func _attack():
	animation_state.travel("Attack")
	
remotesync func _jump():
	animation_state.travel("Jump")
	
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
		
	if is_on_floor() and not is_jump:
		is_jump = true
		_snap = Vector3.ZERO
		translation.y += 0.55
		_velocity.y = 15.0
		rpc_unreliable("_jump")
	
func master_moving(delta):
	.master_moving(delta)
	
	if is_jump and is_on_floor():
		is_jump = false
		animation_state.travel("ToucheGround")
	
func _on_animation_checker_timeout():
	if is_jump:
		return
		
	if move_direction != Vector2.ZERO:
		animation_state.travel("Run")
	else:
		animation_state.travel("Idle")
