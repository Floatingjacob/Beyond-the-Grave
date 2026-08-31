extends PointLight2D

var Direction := Vector2(0, 1)
var Speed := 1
var max_distance := 100

var origin := Vector2(0, 0)

func _ready() -> void:
	$Collision.body_entered.connect(func(body):
		if body.is_in_group("player"):
			body.hit()
			queue_free())
	origin = global_position
func _process(delta: float) -> void:
	position += Direction * Speed * delta
	if abs(origin.x - global_position.x) > max_distance || abs(origin.y - global_position.y) > max_distance:
		free()

func configure(direction, speed, maxDistance):
	Direction = direction
	Speed = speed
	max_distance = maxDistance
