extends CharacterBody3D


var SPEED = 5.0
var MIN_SPEED = 5.0
const JUMP_VELOCITY = 4.5
var coyote_time = 50 # Lenient Jump Time for Players in Milliseconds
var last_collision_ms = 0 # bruh i just added a semicolon again burh
var cashed_jump_time_ms = 0

var max_score : int = 0
var current_score : int = 0
var current_score_seconds : int = 0
var current_score_sub_seconds : float = 0.0

var data_test : Dictionary

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await RenderingServer.frame_post_draw
	get_tree().call_group("Savers","save", data_test)
	pass

func _physics_process(delta: float) -> void:
	var physics_time_ms = Time.get_ticks_usec()/1.0e+3
	var acceptable_jump = is_on_floor() or abs(physics_time_ms-last_collision_ms) <= coyote_time
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if acceptable_jump:
			apply_jump()
		else:
			cashed_jump_time_ms = physics_time_ms

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_leftwards", "move_rightwards", "move_forwards", "move_backwards")
	var direction = (transform.basis*$Yaw.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		#velocity += delta*velocity*100
		SPEED += Vector2(velocity.x,velocity.z).length()*delta*0.05
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		SPEED += -1.0*delta
		SPEED = max(SPEED,MIN_SPEED)
	var last_collisions = get_last_slide_collision()
	move_and_slide()
	var new_collisions = get_last_slide_collision()
	if (not last_collisions) and (new_collisions) and abs(physics_time_ms-cashed_jump_time_ms) <= coyote_time:
		apply_jump()
		pass
	if last_collisions and not new_collisions:
		last_collision_ms = physics_time_ms
	
	var last_coll_count = last_collisions.get_collision_count() if last_collisions else 0
	var new_coll_count = new_collisions.get_collision_count() if new_collisions else 0
	var changed_coll = new_coll_count != last_coll_count
	var raycast_collision : Object = $Yaw/Pitch/Roll/Camera3D/RayCast3D.get_collider()
	get_tree().call_group("DebugDataRecievers","recieve_collision_debug_data", {"last_collision_count": last_coll_count,
	"new_collision_count": new_coll_count,
	"changed?":"✔️" if changed_coll else "❌",
	"velocity": velocity,
	"speed": SPEED,
	"raycast": raycast_collision})
	
	if raycast_collision and Input.is_action_just_pressed("attack"):
		if raycast_collision.has_method("_hit"): raycast_collision.call("_hit", self)
	var lol = 101
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
	


func apply_jump():
	velocity.y = JUMP_VELOCITY

var camera_rotation : Vector2
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		camera_rotation.x -= event.relative.x/7.0
		camera_rotation.y -= event.relative.y/7.0
		
		apply_camera_rotation()
	
	if event.is_action_pressed("save_state"):
		#save(data_test)
		get_tree().call_group("Savers","save", data_test)
	if event.is_action_pressed("load_state"):
		#lOdE(data_test)
		get_tree().call_group("Loaders","lOdE",data_test)

func apply_camera_rotation():
	$Yaw.rotation_degrees.y = camera_rotation.x
	$Yaw/Pitch.rotation_degrees.x = camera_rotation.y

func save(save_data : Dictionary):
	save_data["Player"] = {
		"Velocity": velocity,
		"Speed": SPEED,
		"Position": position,
		"CameraRotation":camera_rotation,
		"MaxScore": max_score,
		"CurrentScore": current_score,
		"CurrentScoreSeconds": current_score_seconds,
		"CurrentScoreSubSeconds": current_score_sub_seconds
	}
	pass

func lOdE(load_data : Dictionary):
	if "Player" in load_data:
		#velocity = load_data["Player"]["Velocity"] # wait i literally forgot this being not loaded is literally core to the gameplay
		
		position = load_data["Player"]["Position"]
		camera_rotation = load_data["Player"]["CameraRotation"]
		max_score = load_data["Player"]["MaxScore"]
		current_score = load_data["Player"]["CurrentScore"]
		current_score_seconds = load_data["Player"]["CurrentScoreSeconds"]
		current_score_sub_seconds = load_data["Player"]["CurrentScoreSubSeconds"]
		apply_camera_rotation()
		update_score_display()


func increment_max_score(amount : int):
	max_score += amount

func increment_current_score(amount : int):
	current_score += amount
	current_score_seconds = $"Speedsplit Display".current_seconds
	current_score_sub_seconds = $"Speedsplit Display".current_sub_seconds
	update_score_display()

func update_score_display():
	#var seconds = $"Speedsplit Display".current_seconds
	#var sub_seconds = $"Speedsplit Display".current_sub_seconds
	$ScoreLabel.text = "%s / %s\nin %s"%[current_score,max_score,$"Speedsplit Display".format_time_string(current_score_seconds,current_score_sub_seconds)]
