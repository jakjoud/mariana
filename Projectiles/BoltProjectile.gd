extends Area2D


export (int) var  direction = 1
export var speed=400
export var damage=2
var state = "shot"


func _physics_process(delta):
	if state != "shot":
		return
		
	
	$AnimatedSprite.flip_h = direction == 1
	if direction == 1:
		$Light2D.rotation_degrees=180
	
	position.x += direction*delta*speed


func _on_BoltProjectile_area_entered(area):
	if "Ennemy" in area.name:
		area.hit(damage)
		state = "hit"
		$AnimatedSprite.play("hit")


func _on_AnimatedSprite_animation_finished():
	if state == "hit":
		queue_free()


func _on_Timer_timeout():
	queue_free()
