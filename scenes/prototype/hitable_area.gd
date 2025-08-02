extends Area3D

class_name Hitable

signal hit(thing)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _hit(thing) -> void:
	emit_signal("hit",thing)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
