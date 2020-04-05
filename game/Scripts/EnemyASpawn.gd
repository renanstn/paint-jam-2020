extends Position3D

export(PackedScene) var SPAWN_SCENE
export(NodePath) var PLAYER_PATH

func _on_Timer_timeout():
	var player = get_node(PLAYER_PATH)
	var instance = SPAWN_SCENE.instance()
	instance.set_player(player)
	instance.global_transform = global_transform
	get_parent().add_child(instance)
