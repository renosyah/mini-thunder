extends StaticBody
class_name BaseMap

export var map_seed :int = 1
export var map_size :float = 200
export var map_scale :float = 1
export var map_land_shander : Resource = preload("res://map/shadermaterial.tres")
export var map_water_shander : Resource = preload("res://map/water_shadermaterial.tres")
export var map_height :int = 20

export var max_stuff = 120
export var stuff_directory = "res://map/model/"
var stuffs = []

func _ready():
	pass
	
func generate_map():
	var noise = OpenSimplexNoise.new()
	noise.seed = map_seed
	noise.octaves = 4
	noise.period = 80.0
	
	var land_mesh = PlaneMesh.new()
	land_mesh.size = Vector2(map_size, map_size)
	land_mesh.subdivide_width = map_size * 0.5
	land_mesh.subdivide_depth = map_size * 0.5
	
	var water_mesh = PlaneMesh.new()
	water_mesh.size = Vector2(map_size, map_size)
	
	var water_mesh_instance = MeshInstance.new()
	water_mesh_instance.mesh = water_mesh
	water_mesh_instance.set_surface_material(0, map_water_shander)
	add_child(water_mesh_instance)
	water_mesh_instance.translation.y -= 1.0
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(land_mesh, 0)
	
	var array_plane = surface_tool.commit()
	
	var data_tool = MeshDataTool.new()
	data_tool.create_from_surface(array_plane, 0)
	
	var custom_gradient = CustomGradientTexture.new()
	custom_gradient.gradient = Gradient.new()
	custom_gradient.type = CustomGradientTexture.GradientType.RADIAL
	custom_gradient.size = Vector2.ONE * map_size + Vector2.ONE
	var data = custom_gradient.get_data()
	data.lock()
	
	for i in range(data_tool.get_vertex_count()):
		var vertext = data_tool.get_vertex(i)
		var value = noise.get_noise_3d(vertext.x * map_scale ,vertext.y * map_scale, vertext.z * map_scale)
		var gradient_value = data.get_pixel((vertext.x + map_size) * 0.5, (vertext.z + map_size) * 0.5).r * 0.8
		value -= gradient_value
		value = clamp(value, -0.075, 2)
		vertext.y = value * (map_height + 2.0)
		data_tool.set_vertex(i, vertext)
		
	var _models = _find_obj_paths()
	var _half_size = int(map_size * 0.5)
	for x in range(-_half_size, _half_size, 8):
		for z in range(-_half_size, _half_size, 8):
			var _pos = Vector3(x,0.0, z)
			var _value = noise.get_noise_3d(_pos.x * map_scale , 0.0, _pos.z * map_scale)
			var gradient_value = data.get_pixel((_pos.x + map_size) * 0.5, (_pos.z + map_size) * 0.5).r * 0.8
			_value -= gradient_value
			if _value > 0.0:
				_pos.y = _value * map_height
				_stuff_placement(_models, _pos)
				
	data.unlock()
	
	for i in range(array_plane.get_surface_count()):
		array_plane.surface_remove(i)
		
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()
	
	var land_mesh_instance = MeshInstance.new()
	land_mesh_instance.mesh = surface_tool.commit()
	land_mesh_instance.set_surface_material(0, map_land_shander)
	land_mesh_instance.create_trimesh_collision()
	add_child(land_mesh_instance)
	
func _stuff_placement(_models :Array, _pos :Vector3):
	var mesh_instance = MeshInstance.new()
	mesh_instance.mesh = load(_models[rand_range(0, _models.size() - 1)])
	add_child(mesh_instance)
	mesh_instance.translation = _pos
	
func _find_obj_paths() -> Array:
	var png_paths := []
	var dir_queue := [stuff_directory]
	var dir: Directory
	var file: String
	while file or not dir_queue.empty():
		if file:
			if dir.current_is_dir():
				dir_queue.append("%s/%s" % [dir.get_current_dir(), file])
				
			elif file.ends_with(".obj.import"):
				png_paths.append("%s/%s" % [dir.get_current_dir(), file.get_basename()])
				
		else:
			if dir:
				dir.list_dir_end()
				
			if dir_queue.empty():
				break
				
			dir = Directory.new()
			dir.open(dir_queue.pop_front())
			dir.list_dir_begin(true, true)
		
		file = dir.get_next()
	
	return png_paths
