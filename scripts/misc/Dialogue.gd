extends Node

func speak(DialogueNode:Node, TypingSounds:Array[AudioStream], HideOnceDone:bool = true, DialogueBox:CanvasLayer = $"/root/Ui/DialogueLayer"):
	DialogueBox.Reset()
	DialogueBox.show()
	
	var i = -1
	
	for m in DialogueNode.get_meta("dialogue"):
		i += 1
		var string = m.split("|")
		
		if string.size() != 3:
			print_rich("[color=red]ERROR: [color=darkred]Dialogue string at position ", i, " is not properly formatted\n[color=yellow]Expected format: [color=#D5B60A]sound_effect_idx|Speaker name|Dialogue to type[/color]")
			return
		
		DialogueBox.setTypingSound(TypingSounds[int(string[0])])
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
	if HideOnceDone:
		DialogueBox.hide()
