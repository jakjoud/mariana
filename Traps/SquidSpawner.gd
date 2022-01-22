extends Sprite

export var speed = 100
const ennemy_prefabs = [
	preload("res://Character/OctopusEnnemy.tscn")
]
export var max_ennemies = 5
var ennemies = 0

func _process(delta):
	rotation_degrees-=speed*delta


func _on_Spawner_timeout():
	
	randomize()
	var prefab = ennemy_prefabs[randi()%len(ennemy_prefabs)]
	var ennemy = prefab.instance()
	ennemy.global_position = global_position
	ennemy.global_position.x += rand_range(-50, 50)
	ennemy.global_position.y += rand_range(-50, 50)
	get_parent().add_child(ennemy)
	ennemies += 1
	if ennemies == max_ennemies:
		$Spawner.stop()
		$AnimationPlayer.play("die")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "die":
		queue_free()


func _on_Activator_body_entered(body):
	if body.name in ["Submarine", "Diver"]:
		$Activator.queue_free()
		$Spawner.start()
