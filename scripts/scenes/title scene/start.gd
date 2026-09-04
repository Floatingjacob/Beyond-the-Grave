extends Button

var fading := false

func _pressed() -> void:
	if not fading:
		fading = true
		await fade()
		get_tree().change_scene_to_file("res://scenes/Pregame Intro.tscn")

func fade():
	if $"../Shade".color.a8 <= 0:
		while $"../Shade".color.a8 < 255:
			$"../Shade".color.a8 += 2
			await get_tree().create_timer(0.001).timeout
	else:
		while $"../Shade".color.a8 > 0:
			$"../Shade".color.a8 -= 2
			await get_tree().create_timer(0.001).timeout
