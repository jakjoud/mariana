extends Node2D

var state="idle"


func _ready():
	randomize()
	$Timer.wait_time += rand_range(-0.5,0.5)


func _on_Timer_timeout():
	state="attack"
	$AnimatedSprite.play("bite")
	$Timer.stop()


func _on_Area2D_body_entered(body):
	print(body.name)
	if body.name in ["Submarine", "Diver"] and state =="attack":
		body.hit(2)


func _on_AnimatedSprite_animation_finished():
	if state == "attack":
		state="idle"
		$AnimatedSprite.play("default")
		$Timer.start()
