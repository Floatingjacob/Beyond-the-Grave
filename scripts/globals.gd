extends Node

var hearts := 9
var isCat := false
var inputAllowed := true
var dialogueOpen := false
var config = ConfigFile.new()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		var window = get_window()
		if window.mode != Window.MODE_FULLSCREEN:
			window.mode = Window.MODE_FULLSCREEN
		else:
			window.mode = Window.MODE_WINDOWED
