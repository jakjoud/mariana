extends KinematicBody2D

export (bool) var is_active = false
export (int) var speed = 120
export (int) var jump_speed = -100
export (int) var gravity = 60
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25


onready var sprite = $Sprite
onready var bubles = $Bubles
onready var idle_bubles = $Bubles/IdleBubles
onready var left_bubles = $Bubles/MovingBublesLeft
onready var right_bubles = $Bubles/MovingBublesRight

var velocity = Vector2.ZERO
var last_dir = 1
var can_shoot = true
const diver_prefab = preload("res://Character/Diver.tscn")
const bolt_prefab = preload("res://Projectiles/BoltProjectile.tscn")
const explosion_prefab = preload("res://VFX/ExplosionAnimation.tscn")
var health = 20
var can_be_hit = true

var alive = true

const hatch_open = preload("res://Resources/SFX/hatch_open.ogg")
const hatch_close = preload("res://Resources/SFX/hatch_close.ogg")

var diver_weapon = null

var paralyzed = false

func set_idle_left():
	sprite.flip_h = false
	bubles.position = $LeftParticles.position
	idle_bubles.emitting = true
	left_bubles.emitting = false
	right_bubles.emitting = false
	
	
func set_idle_right():
	sprite.flip_h = true
	bubles.position = $RightParticles.position
	idle_bubles.emitting = true
	left_bubles.emitting = false
	right_bubles.emitting = false


func set_move_left():
	sprite.flip_h = false
	bubles.position = $LeftParticles.position
	idle_bubles.emitting = false
	left_bubles.emitting = true
	right_bubles.emitting = false
	
func set_move_right():
	sprite.flip_h = true
	bubles.position = $RightParticles.position
	idle_bubles.emitting = false
	left_bubles.emitting = false
	right_bubles.emitting = true

func activate(weapon):
	is_active = true
	$Camera2D.current = true
	$AudioStreamPlayer2D.stream = hatch_close
	$AudioStreamPlayer2D.play()
	diver_weapon = weapon

func get_input():
		
	if Input.is_action_just_pressed("vehicle"):
		var diver = diver_prefab.instance()
		diver.global_position = $SpawnPos.global_position
		diver.activate(self, diver_weapon)
		is_active = false
		get_parent().add_child(diver)
		$AudioStreamPlayer2D.stream = hatch_open
		$AudioStreamPlayer2D.play()
		return
		
	var dir = 0
	if Input.is_action_pressed("right"):
		dir += 1
	if Input.is_action_pressed("left"):
		dir -= 1
	
	if Input.is_action_just_pressed("fire") and can_shoot:
		var bolt = bolt_prefab.instance()
		if dir!=0:
			bolt.direction = dir
		else:
			bolt.direction = last_dir
			
		if bolt.direction == 1:
			bolt.global_position = $ShootingRight.global_position
		else:
			bolt.global_position = $ShootingLeft.global_position
		get_parent().add_child(bolt)
		can_shoot=false
		$ShootingCooldown.start()
		
	if dir == 0:
		if last_dir == -1:
			set_idle_right()
		else:
			set_idle_left()
	else:
		last_dir = dir
		if dir==-1:
			set_move_right()
		else:
			set_move_left()

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

func _physics_process(delta):
	if not is_active or not alive or paralyzed:
		set_idle_left()
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
	$DamageCooldown.start()
	health -= damage
	if health>0:
		$AnimationPlayer.play("hurt")
		get_parent().update_health("sub", health)
	else:
		alive = false
		$ExplosionsTimer.start()
		$DyingTimer.start()
		

func _on_ShootingCooldown_timeout():
	can_shoot = true


func _on_DamageCooldown_timeout():
	can_be_hit = true


func _on_DyingTimer_timeout():
	get_tree().reload_current_scene()


func _on_ExplosionsTimer_timeout():
	randomize()
	var explosion = explosion_prefab.instance()
	explosion.global_position = global_position
	explosion.global_position.x += rand_range(-5,5)
	explosion.global_position.y += rand_range(-5,5)
	get_parent().add_child(explosion)
	explosion.play("default")

func turnoff_light():
	$Light2D.visible = false
