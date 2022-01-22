extends Label

export (String) var svalue
export  var speed=50

func _ready():
	text=svalue

func _process(delta):
	margin_top-=speed*delta
	margin_bottom-=speed*delta+64
