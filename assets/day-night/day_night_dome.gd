extends Spatial
class_name DayNightDome

const day_color = Color.white
const night_color = Color.black

const day_sky_color = Color(0.254902, 0.823529, 1)
const dusk_sky_color = Color(0.172549, 0.094118, 0.027451)
const night_sky_color = Color(0.007843, 0.062745, 0.109804)
const morning_sky_color = Color(0, 0.361847, 0.652344)

onready var background_color = day_sky_color
onready var light_color = day_sky_color
onready var world_environment = $WorldEnvironment
onready var directional_light = $DirectionalLight


# Called when the node enters the scene tree for the first time.
func _ready():
	world_environment.environment.background_color = background_color
	directional_light.light_color = day_color
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_x(0.02 * delta)
	
	if rotation_degrees.x > 80 and rotation_degrees.x < 90:
		background_color = lerp(background_color, dusk_sky_color, 5 * delta)
		directional_light.light_color = lerp(directional_light.light_color, background_color, 5 * delta)
		
	elif rotation_degrees.x > 100:
		background_color = lerp(background_color, night_sky_color, 5 * delta)
		directional_light.light_color = night_color
		rotate_x(0.012 * delta)
		
	elif rotation_degrees.x < -90 and rotation_degrees.x < -80:
		background_color = lerp(background_color, morning_sky_color, 5 * delta)
		directional_light.light_color = lerp(directional_light.light_color, background_color, 5 * delta)
		rotate_x(0.08 * delta)
		
	elif rotation_degrees.x < 60:
		background_color = lerp(background_color, day_sky_color, 5 * delta)
		directional_light.light_color = lerp(directional_light.light_color, day_color, 5 * delta)
		
	world_environment.environment.background_color = background_color
	
	
	
	
	
	
	
	
	
