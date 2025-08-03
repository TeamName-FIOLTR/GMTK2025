extends Node3D
class_name HitCube

enum HitCubeState{
	PAUSED,
	IDLE,
	EXPIRED,
	HIT
}

signal state_changed(hit_state)


var state : HitCubeState:
	set(n_state):
		state = n_state
		emit_signal("state_changed", state)
@export var time_left : float = 10.0

func get_display_material()->Material:
	return $Area3D/CSGBox3D.material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await RenderingServer.frame_pre_draw
	get_tree().call_group("ScoreKeepers","increment_max_score", 1)
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if state != HitCubeState.PAUSED:
		time_left -= delta
	update_cube_state()

func state_to_color()-> Color:
	match state:
		HitCubeState.PAUSED: return Color.YELLOW
		HitCubeState.IDLE: return Color.GREEN
		HitCubeState.EXPIRED: return Color.RED
		HitCubeState.HIT: return Color.CYAN
	return Color.RED

func update_cube_state():
	if not state == HitCubeState.HIT:
		state = HitCubeState.EXPIRED if time_left <= 0.0 else HitCubeState.IDLE
	var color : Color = state_to_color()
	self.get_display_material().set_shader_parameter("color",color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_state(save_data : Dictionary):
	var id = get_instance_id()
	var id_name = "HitCube%s"%id
	save_data[id_name] = {
		"TimeLeft": time_left,
		"WasHit": state == HitCubeState.HIT,
		"IsPaused": state == HitCubeState.PAUSED
	}
	pass

func load_state(load_data : Dictionary):
	var id = get_instance_id()
	var id_name = "HitCube%s"%id
	if id_name in load_data:
		time_left = load_data[id_name]["TimeLeft"]
		if load_data[id_name]["WasHit"]: state = HitCubeState.HIT
		elif load_data[id_name]["IsPaused"]: state = HitCubeState.PAUSED
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
	print_debug("hit")
	if state == HitCubeState.IDLE:
		state = HitCubeState.HIT
		get_tree().call_group("ScoreKeepers","increment_current_score", 1)
	pass # Replace with function body.
