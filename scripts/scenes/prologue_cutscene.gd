extends Node2D

@onready var sounds = [preload("res://assets/audio/sfx/Blip.wav"), preload("res://assets/audio/sfx/Blip 1.wav")]

func _ready() -> void:
	await get_tree().process_frame
	$TBC.hide()
	$/root/Ui/shootCooldown.hide()
	$"/root/Ui/DialogueLayer".hide()
	$"/root/Ui/Hearts".hide()
	await $Sound.finished
	$Sound.stream = load("res://assets/audio/ambient/mood.mp3")
	$Sound.play()
	$Sound.finished.connect($Sound.play) # Loop the mood track
	await fade()
	await speak()
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

func speak(DialogueBox:CanvasLayer = $"/root/Ui/DialogueLayer"):
	DialogueBox.Reset()
	DialogueBox.show()
	
	for m in get_meta("dialogue"):
		var string = m.split("|")
		
		DialogueBox.setTypingSound(sounds[int(string[0])])
		for c in DialogueBox.get_children():
			if c.name == "Speaker":
				c.text = string[1]
				break
		var ss
		var s:String = string[2]
		
		s = s.replace("\\n", "\n")
		ss = s.split("\\p")
		
		for p in ss:
			if p.begins_with("!!"):
				await DialogueBox.fancyType(p.substr(2), true)
			else: await DialogueBox.fancyType(p, false)
			DialogueBox.timer = get_tree().create_timer(DialogueBox.QuickPauseInterval)
			await DialogueBox.timer.timeout
		await DialogueBox.e
	DialogueBox.hide()

#func _input(_event: InputEvent) -> void:
#	if Input.is_action_just_pressed("UI_INTERACT"): 
#		e.emit()
