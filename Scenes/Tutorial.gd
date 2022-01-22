extends Node2D

onready var _transition_rect := $HUD/Transition

onready var doors=[
	$Props/WaterDoor,
	$Props/WaterDoor2,
	$Props/WaterDoor3
]

onready var locks=[
	$Props/WaterLock,
	$Props/WaterLock2,
	$Props/WaterLock3
]

func  set_locks():
	for i in range(len(doors)):
		locks[i].set_door(doors[i])

func _ready():
	$HUD.init_health(20, 10)
	set_locks()


func _on_LockedDoor_body_entered(body):
	if body.name == "Submarine":
		$HUD.show_info("You need to find a lock to open this door")
		$InfoAreas/LockedDoor.queue_free()


func _on_Corridor_body_entered(body):
	if body.name == "Submarine":
		$HUD.show_info("The sub is too big. Get the diver out using shift")
		$InfoAreas/Corridor.queue_free()


func _on_Shooting_body_entered(body):
	if body.name == "Submarine":
		$HUD.show_info("To shoot use spacebar")
		$InfoAreas/Shooting.queue_free()


func update_health(actor, health):
	if actor == "sub":
		$HUD.update_sub_health(health)
	else:
		$HUD.update_pilot_health(health)


func _on_EOL_body_exited(body):
	if body.name == "Submarine" or body.name == "Diver":
		_transition_rect.transition_to("res://Scenes/Level1.tscn")
