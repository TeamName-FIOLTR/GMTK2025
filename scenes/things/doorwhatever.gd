@tool
extends Node3D

@export_tool_button("Fit Door")
var fit_door_callable = Callable(self, "_fit_to_collision")


signal size_changed
@export var size : Vector2 = Vector2.ONE:
	set(n_size):
		size = n_size
		emit_signal("size_changed") # best way to get around on-ready set getters
signal locked_changed
@export var locked : bool = false:
	set(n_locked):
		locked = n_locked
		emit_signal("locked_changed")

signal hit_cubes_changed
@export var hit_cubes : Array[HitCube]:
	set(n_cubes):
		hit_cubes = n_cubes
		emit_signal("hit_cubes_changed")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size_changed.connect(update_door)
	locked_changed.connect(update_door)
	hit_cubes_changed.connect(update_cubes)
	
	update_door()
	update_cubes()
	
	pass # Replace with function body.

func update_door():
	$MeshInstance3D.scale.x = size.x
	$MeshInstance3D.scale.y = size.y
	$MeshInstance3D.position.y = size.y/2.0
	
	$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("size",size)
	$MeshInstance3D.get_surface_override_material(0).set_shader_parameter("locked",locked)
	$TextMeshThingy.get_surface_override_material(0).set_shader_parameter("locked",locked)
	
	$TextMeshThingy.position.y = size.y/2.0 if locked else size.y-0.20
	$TextMeshThingy.mesh.text = "0/12"
	pass

func update_cubes():
	for cube in hit_cubes:
		cube.state_changed.connect(test_locked)
	test_locked(0)

func test_locked(hit_state):
	#if hit_cubes.is_empty():
		#locked = false
		#return
	var total_cubes = hit_cubes.size()
	var total_hits = 0
	for cube in hit_cubes:
		if cube.state == HitCube.HitCubeState.HIT: total_hits += 1
	locked = total_hits != total_hits
	update_door()
	$TextMeshThingy.mesh.text = "%s/%s"%[total_hits,total_cubes]

func _fit_to_collision():
	should_do_the_raycast_thing_ig = true
	pass

var should_do_the_raycast_thing_ig = false

func _physics_process(delta: float) -> void:
	if not should_do_the_raycast_thing_ig: return
	should_do_the_raycast_thing_ig = false
	
	var space_state = get_world_3d().direct_space_state
	var new_size : Vector2 = size
	var door_mid_point : Vector3 = Vector3(0,size.y/2,0.0)
	var edge_vectors : PackedVector3Array = [
											Vector3(size.x/2.0,0.0,0.0)+door_mid_point,
											Vector3(-size.x/2.0,0.0,0.0)+door_mid_point,
											Vector3(0.0,size.y/2.0,0.0)+door_mid_point,
											Vector3(0.0,-size.y/2.0,0.0)+door_mid_point,
											]
	for edge_idx in range(edge_vectors.size()):
		var direction = (edge_vectors[edge_idx]-door_mid_point).normalized()*1000.0+door_mid_point
		var query = PhysicsRayQueryParameters3D.create(global_transform*door_mid_point,global_transform*direction)
		var result = space_state.intersect_ray(query)
		if result:
			edge_vectors[edge_idx] = global_transform.affine_inverse()*result["position"]
		pass
	
	var mid_x : Vector3 = (edge_vectors[0]+edge_vectors[1])/2.0
	var mid_y : Vector3 = (edge_vectors[2]+edge_vectors[3])/2.0
	var new_mid_point : Vector3 = Vector3(mid_x.x,mid_y.y,0)+position
	new_size = Vector2(edge_vectors[0].x-edge_vectors[1].x,edge_vectors[2].y-edge_vectors[3].y)
	print("\n\nposition:\n",new_mid_point-Vector3(0,new_size.y/2.0,0))
	position = new_mid_point-Vector3(0,new_size.y/2.0,0)
	size = new_size
	print("SIZE:\n",new_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
