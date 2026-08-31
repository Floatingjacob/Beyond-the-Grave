extends Sprite2D

@export var hit_cooldown := 1

var hitting := false

func _ready() -> void:
	$Collision.body_entered.connect(func(body):
		if body.is_in_group("player"):
			hitting = true
			while(hitting):
				body.hit()
				await get_tree().create_timer(hit_cooldown).timeout)
	$Collision.body_exited.connect(func(body):
		if body.is_in_group("player"):
			hitting = false)
