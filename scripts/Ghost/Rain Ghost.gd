extends CharacterBody2D

@export var throwing_cooldown := 1
@export var direction := Vector2(0, 1)
@export var speed := 500
@export var max_distance := 200

@onready var Throwable = preload("res://reusables/Ghost Throwable.tscn")

var health := 3
var timer: SceneTreeTimer 

func _ready() -> void:
	timer = get_tree().create_timer(1)
	$HurtBox.body_entered.connect(func(body):
		if body.is_in_group("player"):
			body.call_deferred("hit"))

func _process(delta: float) -> void:
	if timer.time_left == 0:
		timer = get_tree().create_timer(throwing_cooldown)
		throw()
	if Globals.isCat:
		modulate.a = 1
	else: 
		if modulate.a <= 0:
			modulate.a = 0
		else:
			modulate.a = modulate.a - 1 * delta
	$Glow.energy = modulate.a

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
		
func throw():
	var throwable = Throwable.instantiate()
	throwable.configure(direction, speed, max_distance)
	throwable.global_position = global_position
	get_parent().add_child(throwable)
	
