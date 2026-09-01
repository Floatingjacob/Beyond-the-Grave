extends Node2D

var sounds:Array[AudioStream] = [preload("res://assets/audio/sfx/Blip.wav"), preload("res://assets/audio/sfx/Blip 1.wav")]

func _ready() -> void:
	await get_tree().process_frame
	$TBC.hide()
	$"/root/Ui".hide()
	$"/root/Ui/DialogueLayer".hide()
	await $Sound.finished
	$Sound.stream = load("res://assets/audio/ambient/mood.mp3")
	$Sound.play()
	$Sound.finished.connect($Sound.play) # Loop the mood track
	await fade()
	await Dialogue.speak($".", sounds)
	await fade()
	$Prologue.hide()
	$TBC.show()
	await fade()
	await get_tree().create_timer(3).timeout
	await fade()
	get_tree().change_scene_to_file("res://scenes/Title Screen.tscn")

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

#func _input(_event: InputEvent) -> void:
#	if Input.is_action_just_pressed("UI_INTERACT"): 
#		e.emit()
