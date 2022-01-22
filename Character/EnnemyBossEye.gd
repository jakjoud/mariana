extends Area2D

onready var animation_player = $AnimationPlayer
onready var HPBar = $HP/TextureProgress

const projectile_prefab= preload("res://Projectiles/BossProjectile.tscn")

var state = "revealing"

signal revealed
signal died

export var speed = 100

var dir = 1
var health=20
var damage=1
var attacked=true

func reveal():
	animation_player.play("reveal")


func _process(delta):
	if state == "reveal" or state == "dying":
		return
		
	if $DownCast.is_colliding() and "Tile" in $DownCast.get_collider().name:
		dir = -1
	if $UpCast.is_colliding() and "Tile" in $UpCast.get_collider().name:
		dir = 1

	position.y += dir*delta*speed 
	
	if state=="closed" or attacked:
		return
	
	if $LeftCast.is_colliding() and $LeftCast.get_collider().name in ["Submarine", "Diver"]:
		var projectile=projectile_prefab.instance()
		projectile.global_position=global_position
		get_parent().add_child(projectile)
		attacked=true
		$AttackTimer.start()
		
	if $RightCast.is_colliding() and $RightCast.get_collider().name in ["Submarine", "Diver"]:
		var projectile=projectile_prefab.instance()
		projectile.dir=1
		projectile.global_position=global_position
		get_parent().add_child(projectile)
		attacked=true
		$AttackTimer.start()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "reveal":
		state="closed"
		emit_signal("revealed")
		HPBar.visible = true
		$AnimatedSprite.play("closed")
		$OpenEyeTimer.start()
		$AttackTimer.start()
		
	if anim_name=="die":
		emit_signal("died")
		queue_free()
	
	
func hit(damage):
	if state=="open":
		$AnimationPlayer.play("hurt")
		health-=damage
		var progressbar_value=health*100/20
		$HP/TextureProgress.value=progressbar_value
		
		if health<=0:
			$AnimationPlayer.play("die")


func _on_OpenEyeTimer_timeout():
	if state=="closed":
		state="open"
		$AnimatedSprite.play("open")
	elif state=="open":
		state="closed"
		$AnimatedSprite.play("closed")


func _on_EnnemyBossEye_body_entered(body):
	if body.name == "Submarine" or body.name =="Diver":
		body.hit(damage)


func _on_AttackTimer_timeout():
	attacked=false
