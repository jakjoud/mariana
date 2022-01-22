extends StaticBody2D

var health = 6
var state = "up"

func hit(damage):
	health-=damage
	print(health)
	if health<=0:
		state="down"
		$AnimatedSprite.play("destroy")


func _on_AnimatedSprite_animation_finished():
	if state == "down":
		queue_free()
