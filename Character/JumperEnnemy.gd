extends Area2D

var state="idle"
export var speed=200
var direction = -1
var health = 6
export var damage = 1

func _process(delta):
	if state == "idle":
		return
		
	if direction == -1 and $CeilingCast.is_colliding() and "Tile" in $CeilingCast.get_collider().name:
		state = "idle"
		$AnimatedSprite.play("idle")
		$AnimatedSprite.flip_v = true
		direction = 1
		$StateTimer.start()
		return
		
	if direction == 1 and $GroundCast.is_colliding() and "Tile" in $GroundCast.get_collider().name:
		state = "idle"
		$AnimatedSprite.play("idle")
		$AnimatedSprite.flip_v = false
		direction = -1
		$StateTimer.start()
		return
	
	position.y += direction*delta*speed

func _on_StateTimer_timeout():
	state = "jump"
	$AnimatedSprite.play("attack")
	
	
func hit(damage):
	if state=="idle":
		return
	
	else:
		state = "idle"
		$AnimationPlayer.play("die")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()


func _on_JumperEnnemy_body_entered(body):
	if body.name == "Submarine" or body.name =="Diver":
		body.hit(damage)
