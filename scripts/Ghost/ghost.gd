extends "res://scripts/Possessable Body.gd"

@export var patroll_distance := 200
var rushDistance := 500
var patrollOrigin := Vector2(0, 0)
var rushOrigin := Vector2(0, 0)
var patrolling := true
var timer: SceneTreeTimer

func _ready() -> void:
	direction = 1
	speed = 83
	maxHealth = 3
	health = maxHealth
	
	$HurtBox.body_entered.connect(func(body):
		if possessed:
			return
		if body.is_in_group("player"):
			body.call_deferred("hit")
		if body.is_in_group("possessionOrb"):
			print("Body entered")
			possess(body.old_body)
			body.queue_free())
		
	$DetectionZone.body_entered.connect(func(body):
		if possessed or !body.is_in_group("player"):
			return
		rush(sign(body.global_position.x - global_position.x)))
	$DetectionZone.body_exited.connect(func(body):
		if possessed:
			return
		if body.is_in_group("player"):
			$Animation.modulate = Color(1, 1, 1)
			speed = 83
			patrolling = true
			timer.timeout.emit())
	patrollOrigin = global_position

func _process(delta: float) -> void:
	if Globals.isCat or Globals.possessedBody == Globals.PossessableBody.Ghost:
		modulate.a = 1
	else: 
		if modulate.a <= 0:
			modulate.a = 0
		else:
			modulate.a = modulate.a - 1 * delta
	$Glow.energy = modulate.a

func _physics_process(delta: float) -> void:
	if possessed:
		super(delta)
		$Animation.flip_h = direction == 1

		if direction == -1 and (abs(global_position.x) - abs(rushOrigin.x)) + rushDistance <= 0 || direction == 1 and (abs(global_position.x) - abs(rushOrigin.x)) - rushDistance >= 0:
			special = false
			$Animation.modulate = Color(1, 1, 1)
			speed = 83
	
		return
	
	if patrolling:
		if global_position.x >= patrollOrigin.x + patroll_distance:
			direction = -1
		elif global_position.x <= patrollOrigin.x - patroll_distance:
			direction = 1
	$Animation.flip_h = direction == 1
	
	velocity.x = speed * direction
	
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if not possessed:
		return
	if Input.is_action_just_pressed("shoot") and not special:
		special = true
		rushOrigin = global_position
		var mousePos := get_global_mouse_position()
		rush(sign(mousePos.x - global_position.x))

func rush(dir):
	patrolling = false
	$Animation.modulate = Color(1, 0.6, 0)
	velocity = Vector2.ZERO
	speed = 0
	timer = get_tree().create_timer(0.3)
	await timer.timeout
	if not patrolling: # Player could've left the detection zone in the 0.3 seconds
		speed = 500
		direction = dir
		#direction = sign(body.global_position.x - global_position.x)
	#special = false

func hit(body):
	if body.is_in_group("goodProjectile"):
		body.queue_free()
		health -= 1
		$SFX.stream = load("res://assets/audio/sfx/hit.mp3")
		$SFX.play()
		
		if possessed:
			Ui.updateHeartDisplay(health, maxHealth)

		if health < 1:
			hide()
			if possessed:
				unPossess()
			$HurtBox.monitoring = false
			$Collision.set_deferred("disabled", true)
			if $SFX.playing:
				await $SFX.finished
			queue_free()
			
		$Animation.modulate = Color(1, 0.3, 0.4)
		await get_tree().create_timer(0.2).timeout
		$Animation.modulate = Color(1, 1, 1)
		
func possess(possessor: CharacterBody2D):
	Globals.possessedBody = Globals.PossessableBody.Ghost
	super(possessor)
