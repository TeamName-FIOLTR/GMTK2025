extends Hitable

#you can hit this object with the player

class_name HitableWithCollision

func _ready()->void:
	self.body_entered.connect()

func on_body_entered(body)->void:
	pass
