extends Control

onready var audio_player_win:AudioStreamPlayer3D = $AudioStreamPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	audio_player_win.play()

func _on_Timer_timeout():
	get_tree().quit()
