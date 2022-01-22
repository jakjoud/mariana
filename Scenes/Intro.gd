extends Node2D

var state = "intro"
onready var _transition_rect := $GUI/Transition


func _process(delta):
	if state == "intro":
		$Vehicle.position.y += 300*delta


func _on_VehicleEntry_timeout():
	state = "menu"
	$GUI/Panel.visible = true


func _on_Start_button_down():
	_transition_rect.transition_to("res://Scenes/Prologue.tscn")
