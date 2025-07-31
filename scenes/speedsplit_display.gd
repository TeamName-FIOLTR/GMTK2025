extends Control

var current_sub_seconds : float = 0.0
var current_seconds : int = 0
var splits : PackedVector2Array
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	current_sub_seconds += delta
	current_seconds += floori(current_sub_seconds)
	#current_sub_seconds = current_sub_seconds%1.0
	current_sub_seconds = fposmod(current_sub_seconds,1.0)
	#var lol = 101

func update_labels():
	var splits_str : String
	var rendered_splits = splits.slice(splits.size()-10)
	for split in rendered_splits:
		var split_seconds = int(split.x)
		var split_sub_seconds = split.y
		splits_str += "\n"+format_time_string(split_seconds,split_sub_seconds)
		#splits_str += "\n%02d"%(split_seconds/60)+":%02d"%(split_seconds%60)+".%0.2f"%split_sub_seconds
	$"VBoxContainer/Splits Label".text = splits_str
	$"VBoxContainer/Current Time Label".text = format_time_string(current_seconds,current_sub_seconds)
	#$"VBoxContainer/Current Time Label".text = "\n%02d"%(current_seconds/60)+":%02d"%(current_seconds%60)+".%0.2f"%current_sub_seconds

func format_time_string(seconds, sub_seconds):
	return "%02d:"%(seconds/60)+"%02d."%seconds+("%0.2f"%sub_seconds).split(".")[1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_labels()
	pass


func save(save_data : Dictionary):
	var current_time = Vector2(current_seconds,current_sub_seconds)
	splits.push_back(current_time)
	save_data["SplitsDisplay"] = {
		"Splits": splits,
		"CurrentTime": current_time
	}

func lOdE(load_data: Dictionary):
	if "SplitsDisplay" in load_data:
		splits = load_data["SplitsDisplay"]["Splits"]
		var current_time = load_data["SplitsDisplay"]["CurrentTime"]
		current_seconds = current_time.x
		current_sub_seconds = current_time.y
