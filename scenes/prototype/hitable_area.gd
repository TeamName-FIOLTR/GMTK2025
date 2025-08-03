extends Area3D

class_name Hitable

signal hit(thing)
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	self.body_entered.connect(self.on_body_entered)

func on_body_entered(body)->void:
	print(str(body) + "entered")

func _hit(thing) -> void:
	emit_signal("hit",thing)
