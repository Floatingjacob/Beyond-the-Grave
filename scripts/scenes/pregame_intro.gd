extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	$"/root/Ui".hide()
	await fade()
	await Dialogue.speak($".", [load("res://assets/audio/sfx/Blip 1.wav"), load("res://assets/audio/sfx/Blip.wav")])
	await fade()
	get_tree().change_scene_to_file("res://scenes/Level 1.tscn")
	
func fade():
	if $Shade.color.a8 <= 0:
		while $Shade.color.a8 < 255:
			$Shade.color.a8 += 2
			await get_tree().create_timer(0.001).timeout
	else:
		while $Shade.color.a8 > 0:
			$Shade.color.a8 -= 2
			await get_tree().create_timer(0.001).timeout
	await get_tree().create_timer(1).timeout
