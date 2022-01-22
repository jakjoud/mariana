extends StaticBody2D

var state = "closed"

func open():
	$AnimatedSprite.play("openning")
	state = "open"

func _on_AnimatedSprite_animation_finished():
	if state == "open":
		queue_free()
