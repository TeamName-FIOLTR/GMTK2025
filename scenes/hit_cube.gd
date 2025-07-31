extends Node3D
class_name HitCube

enum HitCubeState{
	IDLE,
	EXPIRED,
	HIT
}

var state : HitCubeState
@export var time_left : float = 10.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await RenderingServer.frame_pre_draw
	get_tree().call_group("ScoreKeepers","increment_max_score", 1)
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	time_left -= delta
	update_cube_state()

func update_cube_state():
	if not state == HitCubeState.HIT:
		state = HitCubeState.EXPIRED if time_left <= 0.0 else HitCubeState.IDLE
	var color = Color.RED
	match state:
		HitCubeState.IDLE: color = Color.GREEN
		HitCubeState.EXPIRED: color = Color.RED
		HitCubeState.HIT: color = Color.CYAN
	$Area3D/CSGBox3D.material.set_shader_parameter("color",color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save(save_data : Dictionary):
	var id = get_instance_id()
	var id_name = "HitCube%s"%id
	save_data[id_name] = {
		"TimeLeft": time_left,
		"WasHit": state == HitCubeState.HIT
	}
	pass

func lOdE(load_data : Dictionary):
	var id = get_instance_id()
	var id_name = "HitCube%s"%id
	if id_name in load_data:
		time_left = load_data[id_name]["TimeLeft"]
		if load_data[id_name]["WasHit"]: state = HitCubeState.HIT
		else: state = HitCubeState.IDLE
		update_cube_state()


func _on_area_3d_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	print(camera)
	print(event)
	print(event_position)
	print(normal)
	print(shape_idx)
	pass # Replace with function body.


func _on_area_3d_hit(thing: Variant) -> void:
	if state == HitCubeState.IDLE:
		state = HitCubeState.HIT
		get_tree().call_group("ScoreKeepers","increment_current_score", 1)
	pass # Replace with function body.
