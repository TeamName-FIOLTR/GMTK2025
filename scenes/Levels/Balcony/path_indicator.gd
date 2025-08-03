extends AnimationPlayer

@export var watch_door : DoorWhatever

func play_animation()->void:
	if watch_door.locked:
		play("RESET")
		play("path_indicator")
	else:
		play("RESET")



func _on_doorwhatever_4_locked_changed() -> void:
	self.play_animation()

func lOdE(_load_data : Dictionary)->void:
	play_animation()
