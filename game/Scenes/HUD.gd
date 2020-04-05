extends Control


onready var ammo_label:Label = $MarginContainer/PanelContainer/NinePatchRect/VBoxContainer2/Ammo
onready var kills_label:Label = $MarginContainer/PanelContainer/NinePatchRect/VBoxContainer3/Kills
onready var life_label:Label = $MarginContainer/PanelContainer/NinePatchRect/VBoxContainer/Life

var kills = 0

func _ready():
	# Conecta os signals
	get_parent().get_parent().connect("bullets", self, "_on_bullets_change")
	get_parent().get_parent().connect("kill_something", self, "_kill_something")
	get_parent().get_parent().connect("life", self, "_life")
	
func _on_bullets_change(qnt):
	# Atualiza a munição no HUD
	ammo_label.text = String(qnt)

func _kill_something():
	# Atualiza o contador de kills no HUD
	kills += 1
	kills_label.text = String(kills)

func _life(qnt):
	life_label.text = String(qnt)
