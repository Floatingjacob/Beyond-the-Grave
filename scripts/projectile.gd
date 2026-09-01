extends CharacterBody2D

var speed := 1200.0
var direction := Vector2.ZERO
var origin:Vector2 = Vector2.ZERO
var initialVelocity:Vector2 = Vector2.ZERO

func _ready() -> void:
	
	$Detection.body_entered.connect(func(body):
		if body.has_method("hit"):
			body.hit(self))

func _physics_process(_delta: float) -> void:
	velocity = (direction * speed) + initialVelocity
	if abs(origin.x - global_position.x) > 1000 || abs(origin.y - global_position.y) > 1000:
		queue_free()
	if not is_queued_for_deletion():
		move_and_slide()

func shoot(shootTo: Vector2, initial_velocity: Vector2 = Vector2.ZERO):
	initialVelocity = initial_velocity
	origin = global_position
	direction = (shootTo - global_position).normalized()
	rotation = direction.angle()
