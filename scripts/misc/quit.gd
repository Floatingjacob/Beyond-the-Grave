extends Button

func _pressed() -> void:
	await fade()
	get_tree().quit()
	
func fade():
	if $"../Shade".color.a8 <= 0:
		while $"../Shade".color.a8 < 255:
			$"../Shade".color.a8 += 2
			await get_tree().create_timer(0.001).timeout
	else:
		while $"../Shade".color.a8 > 0:
			$"../Shade".color.a8 -= 2
			await get_tree().create_timer(0.001).timeout
