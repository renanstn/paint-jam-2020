extends Area

func _on_Collectable_body_entered(body):
	if body.name == "Player":
		body.item_collected()
		queue_free()
