extends Control


onready var ammo_label:Label = $MarginContainer/PanelContainer/HBoxContainer/AmmoBox/Ammo
onready var kills_label:Label = $MarginContainer/PanelContainer/HBoxContainer/KillsBox/Kills
onready var life_label:Label = $MarginContainer/PanelContainer/HBoxContainer/LifeBox/Life
onready var coll_label:Label = $MarginContainer/PanelContainer/HBoxContainer/CollBox/Obj

var kills = 0

func _ready():
	# Conecta os signals
	get_parent().get_parent().connect("bullets", self, "_on_bullets_change")
	get_parent().get_parent().connect("kill_something", self, "_kill_something")
	get_parent().get_parent().connect("life", self, "_life")
	get_parent().get_parent().connect("coll", self, "_coll")
	
func _on_bullets_change(qnt):
	# Atualiza a munição no HUD
	ammo_label.text = String(qnt)

func _kill_something():
	# Atualiza o contador de kills no HUD
	kills += 1
	kills_label.text = String(kills)

func _life(qnt):
	life_label.text = String(qnt)

func _coll(qnt):
	coll_label.text = String(qnt)+"/3"
