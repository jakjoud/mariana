extends Area2D

export (Texture) var item_texture
export var weapon_type = "torch"

func _ready():
	$Sprite.texture = item_texture
	$AnimationPlayer.play("default")
	


func _on_Weapon_body_entered(body):

	if body.name == "Diver":
		body.hit(-2)
		queue_free()
