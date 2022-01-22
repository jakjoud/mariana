extends Area2D

var damage=1
var state="charge"

var dir=-1
var speed=300

func _process(delta):
	$AnimatedSprite.flip_h=dir==-1
	if state=="launch":
		position.x+=dir*speed*delta
	

func _on_BossProjectile_body_entered(body):
	if body.name == "Submarine" or body.name =="Diver":
		body.hit(damage)
	queue_free()


func _on_AnimatedSprite_animation_finished():
	if state=="charge": 
		state="launch"
		$AnimatedSprite.play("launch")
