extends Area2D


export (Texture) var off_texture=null;
export (Texture) var on_texture=null;

export (int) var octopi_nb = 0

const octopus_prefab=preload("res://Character/OctopusEnnemy.tscn")

var door = null
var locked = true

func _ready():
	$Sprite.texture = off_texture

func set_door(obj):
	door = obj


func _on_WaterLock_body_entered(body):

	if "Diver" in body.name and door != null and locked:
		locked = false
		$Sprite.texture = on_texture
		door.open()
		$WaitTime.start()
		$Indicator.material.set_shader_param("glow_color", Color.green)
		$Indicator/Light2D.color = Color.green


func _on_WaitTime_timeout():
	randomize()
	for i in range(octopi_nb):
		var octopus = octopus_prefab.instance()
		octopus.global_position = global_position
		octopus.global_position.x += rand_range(-10, 10)
		octopus.global_position.y += rand_range(-10, 10)
		octopus.speed = 60
		get_parent().add_child(octopus)
