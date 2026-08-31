extends AudioStreamPlayer

func _process(delta: float) -> void:
	if !playing: play()
