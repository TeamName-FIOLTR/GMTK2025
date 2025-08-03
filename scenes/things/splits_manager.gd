extends Node
class_name SplitsManager
# <starfire> Manager of the splits! </starfire>


# Array of Split Save States in Chronological Order
var split_states : Array[Dictionary]
# Maximum amount of Splits in the State Array, -1 for unlimited
var max_splits_count : int = -1
# Current Split's Time
var current_split_time : float = 0.0
# Gets the splits as an array of Seconds in Chronological Order
func get_splits() -> PackedFloat64Array:
	var splits : PackedFloat64Array
	for state in split_states:
		splits.append(state["SplitTime"])
	return splits

# Resets the splits array and timer
func reset_splits() -> void:
	split_states.clear()
	current_split_time = 0.0

# Gets the time as a string in MM:SS.MS format because like no language actually does that by default apparently bruh
func format_time(seconds : float, decimals = 2) -> String:
	var minutes : int = floori(seconds/60)
	seconds = fposmod(seconds,60.0)
	var sub_seconds = fposmod(seconds,1.0)
	return ("%02d:%02d.%0Vd".replace("V",str(decimals)))%[minutes,floori(seconds),floori(sub_seconds*pow(10,decimals))]
	pass

# Commit a split to the splits array, resizing if nessicary [br] god i can never spell that word bruh
func commit_split(split_title : String = ""):
	var new_split_state : Dictionary
	new_split_state["SplitTitle"] = split_title
	save_state(new_split_state)
	get_tree().call_group("Savers","save_state",new_split_state)
	split_states.append(new_split_state)
	if max_splits_count > 0 and split_states.size() > max_splits_count:
		split_states.resize(max_splits_count)

# Loads a Split Save State as a data Dictionary
func load_split_state(split_state : Dictionary):
	get_tree().call_group("Loaders","load_state",split_state)
	load_state(split_state)

## Loads the latest Nth split of the splits array, N going in reverse chronological order
func load_latest_split(latest_split_index : int = 0):
	var split_index = (split_states.size()-1)-latest_split_index
	load_split(split_index)
	pass

# Loads the Nth split of the splits array, N going chronological order
func load_split(split_index : int):
	split_index = clampi(split_index,0,split_states.size()-1)
	load_split_state(split_states[split_index])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	current_split_time += delta
	pass

func save_state(save_data : Dictionary):
	save_data["SplitTime"] = current_split_time

func load_state(load_data : Dictionary):
	current_split_time = load_data["SplitTime"]
