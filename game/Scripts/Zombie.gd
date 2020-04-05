extends KinematicBody


const MOVE_SPEED = 3

onready var raycast:RayCast = $RayCast
onready var anim_player:AnimationPlayer = $AnimationPlayer
onready var audio_player:AudioStreamPlayer3D = $AudioStreamPlayer3D

var player = null
var dead = false

func _ready():
	anim_player.play("walking")
	add_to_group("zombies")

func _physics_process(delta):
	if dead:
		return
	if player == null:
		return

	var vector_to_player = player.translation - translation
	vector_to_player = vector_to_player.normalized()
	raycast.cast_to = vector_to_player * 1.5

	move_and_collide(vector_to_player * MOVE_SPEED * delta)

	if raycast.is_colliding():
		var coll = raycast.get_collider()
		if coll != null and coll.name == 'Player':
			if coll.can_be_hurt:
				coll.take_damage()

func set_player(p):
	player = p

func kill():
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("dying")
	audio_player.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
