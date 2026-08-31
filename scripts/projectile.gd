extends Sprite2D

var speed := 1200.0
var direction := Vector2.ZERO
var origin:Vector2 = Vector2.ZERO

func _ready() -> void:
	$Detection.body_entered.connect(func(body):
		if body.has_method("hit"):
			body.hit(self))

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	if abs(origin.x - global_position.x) > 1000 || abs(origin.y - global_position.y) > 1000:
		free()

func shoot(shootTo: Vector2):
	origin = global_position
	direction = (shootTo - global_position).normalized()
	rotation = direction.angle()
