extends HitCube

class_name HitableTriangle

@export var area : Hitable

@export var speed_boost : float = 10.0

func _ready()->void:
	super._ready()
	area.hit.connect(self._on_area_3d_hit)


func get_display_material()->Material:
	return $triangleMesh/Cube.get_surface_override_material(0)

func _on_area_3d_hit(thing : Variant)->void:
	super._on_area_3d_hit(thing)
	if thing is Player:
		(thing as Player).SPEED += speed_boost
