extends CharacterBody2D

@export_category("Camera Limits")

@export var Limit_Left = 0
@export var Limit_Top = 0
@export var Limit_Right = 10000000
@export var Limit_Bottom = 650

var Projectile = preload("res://reusables/Projectile.tscn")

var SPEED = 300.0
const JUMP_VELOCITY = -500.0
var cyoteTimer: float = 0.0
var timer:SceneTreeTimer
var lastDirection: float = 0
var direction:float = 0
var jumping := false
var onCooldown := false
var vulnerable:= true

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout

	$Camera.limit_left = Limit_Left
	$Camera.limit_top = Limit_Top
	$Camera.limit_right = Limit_Right
	$Camera.limit_bottom = Limit_Bottom

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		$Animation.flip_h = lastDirection == -1
		velocity += get_gravity() * delta
	else:
		cyoteTimer = 0.3
		jumping = false


	cyoteTimer = max(0.0, cyoteTimer - delta)
	
	var canJump = is_on_floor() or cyoteTimer > 0.0
	if Globals.inputAllowed:
		direction = Input.get_axis("ui_left", "ui_right")
		
		if Input.is_action_just_pressed("ui_up") and Globals.isCat and canJump:
			jumping = true
			$SFX.stream = load("res://assets/audio/sfx/Jump.wav")
			$SFX.play()
			$Animation.play("catJump")
			velocity.y = JUMP_VELOCITY
			cyoteTimer = 0.0 
		
		if direction and vulnerable:
			if direction != 0:
				lastDirection = direction
				if canJump:
					velocity.x = direction * SPEED
				else:
					velocity.x = abs(velocity.x) * lastDirection
		elif canJump:
			velocity.x = 0
			
	evalAnimation()
	move_and_slide()

func toggleCat():
	Globals.isCat = !Globals.isCat
	if Globals.isCat:
		$"/root/Ui/shootCooldown".modulate.a = 0.5
		$Transform.color = Color8(128, 5, 255)
	else: 
		if not onCooldown:
			$"/root/Ui/shootCooldown".modulate.a = 1
		$Transform.color = Color(1, 1, 0)
	$Transform.emitting = true
	$HumanCollision.set_deferred("disabled", !Globals.isCat)
	$CatCollision.set_deferred("disabled", Globals.isCat)
	
	if Globals.isCat: SPEED = 500
	else: SPEED = 300

func _input(_event: InputEvent) -> void:
	if Globals.inputAllowed:
		if Input.is_action_just_pressed("toggle_cat") and is_on_floor():
			toggleCat()
		if Input.is_action_just_pressed("shoot") and !Globals.isCat and not onCooldown and vulnerable:
			$Animation.flip_h = get_global_mouse_position() - global_position < Vector2.ZERO
			$Animation.play("shoot")
			$Animation.frame = 1
			var projectile = Projectile.instantiate()
			get_parent().add_child(projectile)
			projectile.global_position = global_position
			projectile.shoot(get_global_mouse_position(), velocity)
			onCooldown = true
			$"/root/Ui/shootCooldown".modulate.a = 0.5
			timer = get_tree().create_timer(1)
			await timer.timeout
			if not Globals.isCat:
				$"/root/Ui/shootCooldown".modulate.a = 1
			onCooldown = false
		if Input.is_action_pressed("dodge") and not Globals.isCat:
			if vulnerable:
				dodge()
		else: vulnerable = true

func hit():
	if vulnerable:
		Globals.hearts -= 1
		$SFX.stream = load("res://assets/audio/sfx/Hit.wav")
		$SFX.play()
		if Globals.hearts < 1:
			get_tree().reload_current_scene()
		else:
			get_node("/root/Ui/Hearts/Heart" + str(abs(Globals.hearts - 9))).modulate = Color(1, 1, 1, 0.5)

func evalAnimation():
	if Globals.isCat:
		
		if direction == 0 and velocity == Vector2.ZERO:
			$Animation.play("catJump")
			$Animation.stop()
			$Animation.frame = 0
			$Animation.flip_h = lastDirection == -1
			
		if $Animation.animation == "catJump":
			$Animation.flip_h = lastDirection == -1
			if $Animation.frame == 5:
				if is_on_floor():
					if not $Animation.is_playing():
						$Animation.frame += 1
						$Animation.play()
				elif $Animation.is_playing(): 
					$Animation.pause()
					
		if not jumping and velocity.x != 0:
			if $Animation.animation != "catJump" || $Animation.animation == "catJump" and $Animation.frame == 0:
				$Animation.play("catSprint")
				$Animation.flip_h = direction == 1
	else:
		if $Animation.animation != "shoot" || $Animation.animation == "shoot" and $Animation.frame == 0:
			if velocity.x != 0:
				$Animation.play("walk")
				$Animation.flip_h = direction == -1
			else:
				$Animation.play("idle")
func dodge():
	var inc = false
	vulnerable = false
	
	while not vulnerable:
		
		if not inc and $Animation.modulate.a8 > 100:
			$Animation.modulate.a8 -= 5
		else: inc = true
		
		if inc and $Animation.modulate.a8 < 255:
			$Animation.modulate.a8 += 3
		else: inc = false

		await get_tree().create_timer(0.01).timeout
	$Animation.modulate.a8 = 255
