extends Control

#class SplitLabel extends Control:
	#var time_label : Label
	#var title_label : Label
	#

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.frame_pre_draw.connect(_on_frame_draw_pre)
	
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	pass

func _on_frame_draw_pre():
	#update_labels()
	pass

func update_labels():
	var splits : PackedFloat64Array = GlobalSplitsManager.get_splits()
	var splits_str : String
	var rendered_splits = splits.slice(splits.size()-10)
	for split in rendered_splits:
		splits_str += "\n"+GlobalSplitsManager.format_time(split)
		#splits_str += "\n%02d"%(split_seconds/60)+":%02d"%(split_seconds%60)+".%0.2f"%split_sub_seconds
	$"VBoxContainer/Splits Label".text = splits_str
	var time_string : String = GlobalSplitsManager.format_time(GlobalSplitsManager.current_split_time,3)
	var time_string_splits = time_string.split(".")
	var fancy_time_string = "[b]"+time_string_splits[0]+"[/b]."+time_string_splits[1]
	$"VBoxContainer/Current Time Label".text = fancy_time_string
	
	queue_redraw()
	#$"VBoxContainer/Current Time Label".text = GlobalSplitsManager.format_time(GlobalSplitsManager.current_split_time,3)
	#if $"VBoxContainer/Current Time Label".text.length() > 8:
		#print($"VBoxContainer/Current Time Label".text)
	#$"VBoxContainer/Current Time Label".text = "\n%02d"%(current_seconds/60)+":%02d"%(current_seconds%60)+".%0.2f"%current_sub_seconds

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_labels()
	pass

func _draw() -> void:
	draw_string($"VBoxContainer/Splits Label".get_theme_font("normal_font"),$"VBoxContainer/Splits Label".position-Vector2(0,-30),"test")
	pass

func save_state(save_data : Dictionary):
	pass

func load_state(load_data: Dictionary):
	pass
