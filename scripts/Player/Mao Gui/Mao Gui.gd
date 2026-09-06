extends "res://scripts/Player/Player.gd"

var slamLand := false
var doubleJumped := false

func _ready() -> void:
	DEFAULT_SPEED = 400
	shootCooldown = 0.5
	await super()

func _physics_process(delta: float) -> void:
	if is_on_floor():
		if slamLand:
			slamLand = false
			$SFX.stream = load("res://assets/audio/sfx/land.mp3")
			$SFX.play()
			$Land.global_position = global_position + Vector2(0, 50)
			$Land.emitting = true
		doubleJumped = false
	
	if Input.is_action_just_pressed("ui_up") and Globals.isCat and not is_on_floor() and not doubleJumped:
		$SFX.stream = load("res://assets/audio/sfx/double jump.mp3")
		$SFX.play()
		$"Double Jump".emitting = true
		doubleJumped = true
		var vel:Vector2 = velocity
		velocity = Vector2((abs(vel.x) + 300) * lastDirection, JUMP_VELOCITY - 300)
		
	if Input.is_action_just_pressed("ui_down") and Globals.isCat and not is_on_floor():
		slamLand = true
		velocity = Vector2((abs(velocity.x) + 1000) * lastDirection, 2000)
	super(delta)
