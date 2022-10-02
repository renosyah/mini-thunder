extends BaseMap

export var size :float = 200

func _ready():
	var noise = OpenSimplexNoise.new()
	
	noise.seed = 1
	noise.period = 80.0
	noise.octaves = 4
	
	var land_mesh = PlaneMesh.new()
	land_mesh.size = Vector2(size, size)
	land_mesh.subdivide_width = size * 0.5
	land_mesh.subdivide_depth = size * 0.5
	
	var water_mesh = PlaneMesh.new()
	water_mesh.size = Vector2(size, size)
	water_mesh.subdivide_width = size * 0.5
	water_mesh.subdivide_depth = size * 0.5
	
	var material : SpatialMaterial = SpatialMaterial.new()
	material.albedo_color =Color(0, 0.317647, 0.443137, 0.584314)
	water_mesh.surface_set_material(0,material)
	
	var water_mesh_instance = MeshInstance.new()
	water_mesh_instance.mesh = water_mesh
	add_child(water_mesh_instance)
	
	var surface_tool = SurfaceTool.new()
	surface_tool.create_from(land_mesh, 0)
	
	var array_plane = surface_tool.commit()
	
	var data_tool = MeshDataTool.new()
	data_tool.create_from_surface(array_plane, 0)

	for i in range(data_tool.get_vertex_count()):
		var vertext = data_tool.get_vertex(i)
		var value = noise.get_noise_3d(vertext.x ,vertext.y, vertext.z)
		vertext.y = value * 40
		data_tool.set_vertex(i, vertext)
		
	for i in range(array_plane.get_surface_count()):
		array_plane.surface_remove(i)
		
	data_tool.commit_to_surface(array_plane)
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.create_from(array_plane, 0)
	surface_tool.generate_normals()
	
	var mesh_instance = MeshInstance.new()
	mesh_instance.mesh = surface_tool.commit()
	mesh_instance.set_surface_material(0, preload("res://map/shadermaterial.tres"))
	mesh_instance.create_trimesh_collision()
	add_child(mesh_instance)
	
