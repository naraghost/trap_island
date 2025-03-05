@tool
extends Node3D
class_name Cube

# This node is called cube but actually it's a 3D isometric rectangle of any size
var top_mesh: MeshInstance3D
var front_mesh: MeshInstance3D
var right_mesh: MeshInstance3D
var static_body: StaticBody3D
var collision_shape: CollisionShape3D
# var xray_material: ShaderMaterial
# var top_xray_material: ShaderMaterial

var total_size:Vector3 = Vector3.ZERO

var materials_initialized: bool = false

@onready var player: PlayerCharacter = get_tree().get_first_node_in_group("player")
@onready var camera: Camera3D = get_viewport().get_camera_3d()

@export var tile: TextureTile = null:
	set(value):
		tile = value
		if value:
			setup_tile()
@export var tile_offset: Vector2 = Vector2.ZERO:
	set(value):
		tile_offset = value
		if tile:
			setup_tile()
@export var tile_scale: Vector3 = Vector3(1,1,1):
	set(value):
		tile_scale = value
		if tile:
			setup_tile()

@export var cube_size: Vector3 = Vector3(0.5, 0.5, 0.5):
	set(value):
		cube_size = value
		if is_inside_tree():
			init()

#@export var custom_top_material: StandardMaterial3D:
	#set(value):
		#custom_top_material = value
		#if is_inside_tree() and top_mesh:
			#setup_face_material(top_mesh, value)
#
#@export var custom_front_material: StandardMaterial3D:
	#set(value):
		#custom_front_material = value
		#if is_inside_tree() and front_mesh:
			#setup_face_material(front_mesh, value)
#
#@export var custom_right_material: StandardMaterial3D:
	#set(value):
		#custom_right_material = value
		#if is_inside_tree() and right_mesh:
			#setup_face_material(right_mesh, value)

var custom_top_material: StandardMaterial3D = StandardMaterial3D.new()
var custom_front_material: StandardMaterial3D = StandardMaterial3D.new()
var custom_right_material: StandardMaterial3D = StandardMaterial3D.new()

@export var opacity_when_occluding: float = 0.5
@export var fade_distance: float = 2.0

func _ready():
	if !Engine.is_editor_hint():
		OptionsManager.options_changed.connect(_on_options_changed)
	
	if tile:
		setup_tile()
	
	if !static_body:
		create_collision()
	# setup_xray()
	init()
	init_materials()
	
	# Ensure process is running
	set_process(true)
	
	# Set render layers for all faces
	setup_render_layers()

func setup_render_layers():
	var faces = [front_mesh, right_mesh, top_mesh]
	for face in faces:
		if face:
			face = face as MeshInstance3D
			face.visibility_range_begin = 0.0
			if face.material_override:
				face.material_override.render_priority = -1
				face.material_override.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_ALWAYS

func setup_tile():
	for mat in [custom_front_material, custom_top_material, custom_right_material]:
		mat = mat as StandardMaterial3D
		mat.albedo_color = tile.modulate
		mat.uv1_triplanar = true
		mat.uv1_offset = Vector3(tile_offset.x,tile_offset.y,0)
		mat.uv1_scale = tile_scale
	if tile.front_texture:
		custom_front_material.albedo_texture = StaticOptimize.change_texture_quality(tile.front_texture)
	if tile.top_texture:
		custom_top_material.albedo_texture = StaticOptimize.change_texture_quality(tile.top_texture)
	if tile.right_texture:
		custom_right_material.albedo_texture = StaticOptimize.change_texture_quality(tile.right_texture)
	
	if !top_mesh:
		create_meshes()
	else:
		if custom_front_material:
			setup_face_material(front_mesh, custom_front_material)
		if custom_right_material:
			setup_face_material(right_mesh, custom_right_material)
		if custom_top_material:
			setup_face_material(top_mesh, custom_top_material)

func setup_face_material(mesh: MeshInstance3D, material: StandardMaterial3D):
	if material and mesh:
		var mat:StandardMaterial3D = material.duplicate()
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		# mat.no_depth_test = false
		mat.render_priority = -1
		if mesh == right_mesh:
			mat.cull_mode = BaseMaterial3D.CULL_FRONT
		mesh.material_override = mat
		

func create_collision():
	static_body = StaticBody3D.new()
	static_body.collision_layer = 2
	add_child(static_body)
	
	collision_shape = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	collision_shape.shape = shape
	static_body.add_child(collision_shape)

func create_face_mesh() -> MeshInstance3D:
	var mesh = MeshInstance3D.new()
	mesh.mesh = QuadMesh.new()
	mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	
	mesh.visibility_range_begin = 1
	mesh.visibility_range_end = -1
	
	# Create and set up default material
	var material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.cull_mode = BaseMaterial3D.CULL_BACK
	material.albedo_color = Color(1, 1, 1, 1)
	#material.depth_draw_mode = BaseMaterial3D.DEPTH_DRAW_ALWAYS
	# material.no_depth_test = false
	material.blend_mode = BaseMaterial3D.BLEND_MODE_MIX
	# material.depth_test_enabled = true
	# material.render_priority = 1
	mesh.material_override = material
	
	add_child(mesh)
	return mesh

func create_meshes():
	# Create visible face meshes for isometric view
	front_mesh = create_face_mesh()
	right_mesh = create_face_mesh()
	top_mesh = create_face_mesh()
	
	# Rotate faces appropriately
	right_mesh.rotation_degrees.y = -90 # Right face (+X)
	top_mesh.rotation_degrees.x = -90 # Top face (+Y)
	
	# Setup materials if they exist
	if custom_front_material:
		setup_face_material(front_mesh, custom_front_material)
	if custom_right_material:
		setup_face_material(right_mesh, custom_right_material)
	if custom_top_material:
		setup_face_material(top_mesh, custom_top_material)

func update_position():
	if !top_mesh:
		return
		
	var half_size = cube_size / 2
	
	# Position visible faces
	if front_mesh:
		front_mesh.position = Vector3(0, half_size.y, half_size.z)
	if right_mesh:
		right_mesh.position = Vector3(half_size.x, half_size.y, 0)
		
	# Position top mesh slightly above others
	top_mesh.position.y = cube_size.y + 0.00001
	
	# Update collision shape position
	if collision_shape:
		collision_shape.position.y = cube_size.y / 2

func init():
	if !top_mesh:
		create_meshes()
	if !static_body or !collision_shape:
		create_collision()
	
	update_position()
	
	# Update mesh sizes according to their orientation
	if front_mesh and front_mesh.mesh:
		front_mesh.mesh.size = Vector2(cube_size.x, cube_size.y) # Front face uses width (x) and height (y)
	
	if right_mesh and right_mesh.mesh:
		right_mesh.mesh.size = Vector2(cube_size.z, cube_size.y) # Right face uses depth (z) and height (y)
	
	if top_mesh and top_mesh.mesh:
		top_mesh.mesh.size = Vector2(cube_size.x, cube_size.z) # Top face uses width (x) and depth (z)
		if custom_top_material:
			setup_face_material(top_mesh, custom_top_material)
	
	# Update collision shape size
	if collision_shape and collision_shape.shape:
		collision_shape.shape.size = cube_size

func init_materials():
	if materials_initialized:
		return
	
	# Store default materials if custom ones aren't set
	if front_mesh and !custom_front_material:
		custom_front_material = front_mesh.material_override.duplicate()
	if right_mesh and !custom_right_material:
		custom_right_material = right_mesh.material_override.duplicate()
	if top_mesh and !custom_top_material:
		custom_top_material = top_mesh.material_override.duplicate()
		
	materials_initialized = true

func _on_options_changed(option) -> void:
	if option == "texture-quality" and tile:
		print("quality changed")
		setup_tile()
