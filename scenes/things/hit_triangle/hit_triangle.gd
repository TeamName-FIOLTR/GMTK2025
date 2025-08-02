extends HitCube

class_name HitableTriangle

@export var area : Hitable

func _ready()->void:
	super._ready()
	area.hit.connect(self._on_area_3d_hit)

