extends Node3D

@export var level_path : String = ""

func load_level()->void:
	print_debug("loading a new level!")

func _ready() -> void:
	$Area3D.body_entered.connect(self.on_body_entered)

func on_body_entered(body)->void:
	get_tree().change_scene_to_file(self.level_path)
