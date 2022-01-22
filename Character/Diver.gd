extends KinematicBody2D

export (bool) var is_active = false
export (int) var speed = 80
export (int) var jump_speed = -100
export (int) var gravity = 60
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO
var last_dir = 0

var current_vehicle = null

var health = 10
var can_be_hit = true

var alive = true

var weapon = null
var shooting = false
var target = null

func get_input():
	if not is_active:
		return
		
	if Input.is_action_just_pressed("vehicle"):
		if global_position.distance_to(current_vehicle.global_position)<60:
			current_vehicle.activate(weapon)
			queue_free()
		
	var dir = 0
	if Input.is_action_pressed("right"):
		dir += 1
	if Input.is_action_pressed("left"):
		dir -= 1
	
	if dir == -1:
		$AnimatedSprite.flip_h = true
		$Light2D.position.x = 4
		$BurnArea.position.x = -17
		$Light2D.rotation_degrees = 180
	if dir == 1:
		$AnimatedSprite.flip_h = false
		$Light2D.position.x = -4
		$BurnArea.position.x = 17
		$Light2D.rotation_degrees = 0
	
	if Input.is_action_pressed("fire") and weapon != null:
		$AnimatedSprite.play("shoot")
		shooting = true
	else:
		shooting = false
		
	if dir !=0:
		shooting = false
		$AnimatedSprite.play("swim")
		$Bubles.gravity.x= -dir*150
	else:
		if not shooting:
			$AnimatedSprite.play("idle")
		$Bubles.gravity.x=0
	
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	$BurnArea/Light2D.enabled = shooting

func activate(vehicle, pickedup):
	$Camera2D.current = true
	is_active = true
	current_vehicle = vehicle
	weapon = pickedup

func _physics_process(delta):
	if not is_active or not alive:
		return
		
	get_input()

	velocity.y += gravity * delta
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if Input.is_action_pressed("up"):
		velocity.y = jump_speed

func hit(damage):
	if not can_be_hit:
		return
	can_be_hit = false
	$DamageTimer.start()
	health -= damage
	if health>0:
		$AnimationPlayer.play("hurt")
		get_parent().update_health("pilot", health)
	else:
		alive = false
		$AnimatedSprite.play("die")


func _on_DamageTimer_timeout():
	can_be_hit = true


func _on_AnimatedSprite_animation_finished():
	if not alive:
		get_tree().reload_current_scene()

func equip(picked_weapon):
	weapon = picked_weapon


func _on_BurnArea_area_entered(area):
	if "Obstacle" in area.name or "Ennemy" in area.name:
		target = area
		$TorchTimer.start()

func _on_BurnArea_body_entered(body):
	if "Obstacle" in body.name or "Ennemy" in body.name:
		target = body
		$TorchTimer.start()


func _on_BurnArea_body_exited(body):
	target = null
	$TorchTimer.stop()


func _on_TorchTimer_timeout():
	if target == null:
		$TorchTimer.stop()
		return
	if not shooting:
		return
	print(target.name)
	target.hit(1)


func _on_BurnArea_area_exited(area):
	target = null
	$TorchTimer.start()
