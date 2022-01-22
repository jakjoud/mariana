extends Area2D

export (Texture) var weapon_texture
export var weapon_type = "torch"

func _ready():
	$Sprite.texture = weapon_texture
	$AnimationPlayer.play("default")
	


func _on_Weapon_body_entered(body):

	if body.name == "Diver":
		body.equip(weapon_type)
		queue_free()
