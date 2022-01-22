extends Node2D

onready var doors=[
	$Props/WaterDoor,
	$Props/WaterDoor2,
	$Props/WaterDoor3,
	$Props/WaterDoor4,
	
]

onready var locks=[
	$Props/WaterLock,
	$Props/WaterLock2,
	$Props/WaterLock3,
	$Props/WaterLock4,
	
]

onready var _transition_rect := $HUD/Transition

func  set_locks():
	for i in range(len(doors)):
		locks[i].set_door(doors[i])

func _ready():
	$HUD.init_health(20, 10)
	set_locks()

func update_health(actor, health):
	if actor == "sub":
		$HUD.update_sub_health(health)
	else:
		$HUD.update_pilot_health(health)


func _on_EOL_body_exited(body):
	if body.name == "Submarine" or body.name == "Diver":
		get_tree().change_scene("res://Scenes/Tutorial.tscn")


func _on_Torsh_body_entered(body):

	if body.name == "Diver":
		$HUD.show_info("You need a plasma torch")
		$InfoAreas/Torch.queue_free()


func _on_EOL_body_entered(body):

	if body.name == "Submarine" or body.name == "Diver":
		_transition_rect.transition_to("res://Scenes/BossLevel1.tscn")
