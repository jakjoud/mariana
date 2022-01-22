extends Node2D

onready var shockwave = $ShockWave
onready var animation = $ShockWave/AnimationPlayer
onready var submarine = $Submarine
onready var boss = $EnnemyBossEye
onready var _transition_rect := $HUD/Transition


func _ready():
	submarine.turnoff_light()

func _on_BossActivation_body_entered(body):
	if body.name in ["Submarine","Diver"]:
		$BossActivation.queue_free()
		shockwave.visible = true
		animation.play("shock")
		submarine.paralyzed = true
		boss.reveal()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shock":
		shockwave.visible = true
	
func update_health(actor, health):
	if actor == "sub":
		$HUD.update_sub_health(health)
	else:
		$HUD.update_pilot_health(health)

func _on_EnnemyBossEye_revealed():
	submarine.paralyzed = false


func _on_EnnemyBossEye_died():
	_transition_rect.transition_to("res://Scenes/Epilogue.tscn")
