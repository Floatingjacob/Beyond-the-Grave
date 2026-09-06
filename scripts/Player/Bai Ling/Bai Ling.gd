extends "res://scripts/Player/Player.gd"

func _ready() -> void:
	DEFAULT_SPEED = 300
	shootCooldown = 1.0
	await super()
