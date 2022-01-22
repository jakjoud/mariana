extends AnimatedSprite




func _on_ExplosionAnimation_animation_finished():
	queue_free()
