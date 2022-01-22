extends CanvasLayer


onready var infoLabel = $InfoPanel/Label
onready var infoPanel = $InfoPanel

onready var subhp = $HealthBars/Panel/SubHPBar
onready var pilothp = $HealthBars/Panel/PilotHPBar

var sub_hp_max = 20
var pilot_hp_max = 10

func init_health(sub, pilot):
	sub_hp_max = sub
	pilot_hp_max = pilot
	

func update_sub_health(sub):
	subhp.value = sub*100/sub_hp_max
	
func update_pilot_health(pilot):
	pilothp.value = pilot*100/pilot_hp_max

func show_info(text):
	infoLabel.text = text
	infoPanel.visible = true
	$InfoDisplayed.start()

func _on_InfoDisplayed_timeout():
	infoPanel.visible = false
