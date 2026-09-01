extends CharacterBody2D

@export var patroll_distance := 200
var patrollOrigin := Vector2(0, 0)
var direction := 1
var patrolling := true
var health := 3
var speed = 5000
var timer: SceneTreeTimer

func _ready() -> void:
	$HurtBox.body_entered.connect(func(body):
		if body.is_in_group("player"):
			body.call_deferred("hit"))
	$DetectionZone.body_entered.connect(rush)
	$DetectionZone.body_exited.connect(func(body):
		if body.is_in_group("player"):
			$Animation.modulate = Color(1, 1, 1)
			speed = 5000
			patrolling = true
			timer.timeout.emit())
	patrollOrigin = global_position

func _process(delta: float) -> void:
	if Globals.isCat:
		modulate.a = 1
	else: 
		if modulate.a <= 0:
			modulate.a = 0
		else:
			modulate.a = modulate.a - 1 * delta
	$Glow.energy = modulate.a

func _physics_process(delta: float) -> void:
	
	if patrolling:
		if global_position.x >= patrollOrigin.x + patroll_distance:
			direction = -1
		elif global_position.x <= patrollOrigin.x - patroll_distance:
			direction = 1
	
	$Animation.flip_h = direction == 1
	
	velocity.x = speed * delta * direction
	
	move_and_slide()

func rush(body):
	if body.is_in_group("player"):
		patrolling = false
		$Animation.modulate = Color(1, 0.6, 0)
		velocity = Vector2.ZERO
		speed = 0
		timer = get_tree().create_timer(0.3)
		await timer.timeout
		if not patrolling: # Player could've left the detection zone in the 0.3 seconds
			speed = 30000
			direction = sign(body.global_position.x - global_position.x)

func hit(body):
	if body.is_in_group("goodProjectile"):
		body.queue_free()
		health -= 1
		$SFX.stream = load("res://assets/audio/sfx/hit.mp3")
		$SFX.play()
		if health < 1:
			hide()
			$HurtBox.monitoring = false
			$Collision.set_deferred("disabled", true)
			if $SFX.playing:
				await $SFX.finished
			queue_free()
		$Animation.modulate = Color(1, 0.3, 0.4)
		await get_tree().create_timer(0.2).timeout
		$Animation.modulate = Color(1, 1, 1)
