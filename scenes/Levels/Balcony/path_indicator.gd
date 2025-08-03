extends AnimationPlayer

var locked : bool = false

func play_animation()->void:
	if not locked:
		play("path_indicator")
	else:
		play_backwards("path_indicator")



func _on_doorwhatever_4_locked_changed(locked) -> void:
	self.locked = locked
	self.play_animation()

func lOdE(_load_data : Dictionary)->void:
	play_animation()
