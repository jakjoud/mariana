extends Node2D
const st_prefab=preload("res://Props/ScrollingText.tscn")
export var text=[
	"Epilogue",
	"Thus, the dreamer returned to its original dimension",
	"And the valiant hero continued his quest of looking for survivors",
	"But, my wife got into my office an told me it is already 1am",
	"And I need to work early tomorrow",
	"This has been a blast, thank you for playing",
	"Please press any key to restart the game"
]

var index = 0
var state="text"

func _input(event):
	if state =="text":
		return
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene("res://Scenes/Intro.tscn")

func _on_Timer_timeout():
	if index==len(text):
		state="continue"
	else:
		var sc=st_prefab.instance()
		sc.svalue=text[index]
		$CanvasLayer/Panel.add_child(sc)
		index+=1
