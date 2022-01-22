extends Node2D
const st_prefab=preload("res://Props/ScrollingText.tscn")
export var text=[
	"Prologue",
	"Year 2050",
	"Global warming caused the sea level to rise ",
	"Civilizations were put to trials, and few survived",
	"In this difficult world, one man makes a last stand against tyrany",
	"Sacreficing everything for his ideals. ",
	"His tale is a tale of self doubt and agony",
	"This game has nothing to do with his story, I just thought it  was cool",
	"So here you go, a game with a submarine, monsters and puzzles",
	"By the way the name of the submarine is a pun not a typo",
	"I know how to write Nautilus, I have a PhD for goodness sake",
	"Please press any key to start"
]

var index = 0
var state="text"

func _input(event):
	if state =="text":
		return
	if event is InputEventKey:
		if event.pressed:
			get_tree().change_scene("res://Scenes/Tutorial.tscn")

func _on_Timer_timeout():
	if index==len(text):
		state="continue"
	else:
		var sc=st_prefab.instance()
		sc.svalue=text[index]
		$CanvasLayer/Panel.add_child(sc)
		index+=1
