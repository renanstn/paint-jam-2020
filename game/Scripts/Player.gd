extends KinematicBody

export(float, 1, 10) var MOVE_SPEED = 4
export(float, 0, 1) var MOUSE_SENS = 0.2
export(int) var MAX_BULLETS = 6
export(int) var MAX_LIFE = 100

onready var anim_player:AnimationPlayer = $AnimationPlayer
onready var raycast:RayCast = $RayCast
onready var audio_player_shoot:AudioStreamPlayer3D = $AudioStreamPlayer3D
onready var audio_player_walk:AudioStreamPlayer3D = $AudioStreamPlayer3D2
onready var audio_player_reloading:AudioStreamPlayer3D = $AudioStreamPlayer3D3
onready var audio_player_hit:AudioStreamPlayer3D = $AudioStreamPlayer3D4
onready var audio_player_coll:AudioStreamPlayer3D = $AudioStreamPlayer3D5
onready var audio_player_game_over:AudioStreamPlayer3D = $AudioStreamPlayer3D6
onready var audio_player_win:AudioStreamPlayer3D = $AudioStreamPlayer3D7
onready var reload_timer:Timer = $ReloadTimer
onready var can_be_hurt_timer:Timer = $CanBeHurtTimer

var bullets:int = MAX_BULLETS
var can_fire:bool = true
var reloading:bool = false
var can_be_hurt:bool = true
var life:int = MAX_LIFE
var points:int = 0

signal bullets(qnt)
signal reloading(yes)
signal life(qnt)
signal coll(qnt)
signal kill_something


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)
	audio_player_game_over.play()

func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		kill()
	if bullets < 1 and not reloading:
		reloading = true
		can_fire = false
		emit_signal("reloading", true)
		audio_player_reloading.play()
		reload_timer.start()

func _physics_process(delta):
	# Movimentação ------------------------------------------------------------
	var move_vec:Vector3 = Vector3()
	if Input.is_action_pressed("move_forwards"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vec * MOVE_SPEED * delta)
	
	# Atirar ------------------------------------------------------------------
	if Input.is_action_just_pressed("shoot") and can_fire:
		bullets -= 1
		anim_player.stop()
		anim_player.play("shoot")
		audio_player_shoot.play()
		emit_signal("bullets", bullets)
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()
			emit_signal("kill_something")

	# Animação e som ao caminhar ----------------------------------------------
	if anim_player.current_animation != "walking" \
		and anim_player.current_animation != "shoot" \
		and move_vec != Vector3.ZERO:
			anim_player.play("walking")
			if not audio_player_walk.playing:
				audio_player_walk.play()

	if move_vec == Vector3.ZERO:
		audio_player_walk.stop()

func take_damage():
	can_be_hurt = false
	can_be_hurt_timer.start()
	life -= 10
	emit_signal("life", life)
	audio_player_hit.play()
	if life <= 0:
		kill()
		
func item_collected():
	points += 1
	emit_signal("coll", points)
	if points == 3:
		audio_player_win.play()
	else:
		audio_player_coll.play()
	

func kill():
	get_tree().reload_current_scene()

func _on_ReloadTimer_timeout():
	bullets = MAX_BULLETS
	can_fire = true
	reloading = false
	emit_signal("reloading", false)
	emit_signal("bullets", bullets)

func _on_CanBeHurtTimer_timeout():
	can_be_hurt = true
