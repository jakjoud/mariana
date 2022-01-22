extends Area2D

export var health=6

var target = null
var state = "idle"

export var speed = 40
export var damage = 2

func update_target():
	var submarine = get_parent().get_parent().get_node("Submarine")
	if submarine == null:
		return
	if submarine.is_active:
		target = submarine
	else:
		target = get_parent().get_parent().get_node("Diver")

func _ready():
	update_target()

func _process(delta):
	if state=="dying":
		return
		
	update_target()
	if target == null:
		return
	
	if state == "idle" and global_position.distance_to(target.global_position) < 300:
		state = "seek"
	
	if state == "idle":
		return
	var direction = target.global_position - global_position
	direction = direction.normalized()
	
	position.x += direction.x*delta*speed
	position.y += direction.y*delta*speed
	
	$AnimatedSprite.flip_h = direction.x>0

func hit(damage):
	health-=damage
	if health>0:
		$AnimationPlayer.play("hit")
	else:
		state="dying"
		$AnimatedSprite.play("die")
		$AnimationPlayer.play("die")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die" and state == "dying":
		queue_free()


func _on_OctopusEnnemy_body_entered(body):
	if body.name == target.name:
		target.hit(damage)
