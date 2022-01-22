extends Node2D

var state = "closed"

func _on_Activation_body_entered(body):
	if body.name == "Submarine":
		$AnimatedSprite.play("openning")
		$Activation.queue_free()
		state = "open"
		

func _on_AnimatedSprite_animation_finished():
	if state == "open" and $AnimatedSprite.animation == "openning":
		$DoorBody.queue_free()
		
		
