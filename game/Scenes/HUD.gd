extends Control


onready var ammo_label:Label = $MarginContainer/HBoxContainer/AmmoBG/Ammo
onready var kills_label:Label = $MarginContainer/HBoxContainer/KillsBG/Kills

var kills = 0

func _ready():
	get_parent().get_parent().connect("bullets", self, "_on_bullets_change")
	get_parent().get_parent().connect("kill_something", self, "_kill_something")
	
func _on_bullets_change(qnt):
	ammo_label.text = String(qnt)

func _kill_something():
	kills += 1
	kills_label.text = String(kills)
