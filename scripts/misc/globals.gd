extends Node

var hearts := 9
var isCat := false
var inputAllowed := true
var dialogueOpen := false
var icons: Array[Texture2D] = [load("res://assets/textures/ui/transformCat.png"), load("res://assets/textures/ui/transformHuman.png")]
var config = ConfigFile.new()
var transformDebounce:SceneTreeTimer

func _ready() -> void:
	await get_tree().process_frame
	Globals.transformDebounce = get_tree().create_timer(0.1)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("fullscreen"):
		var window = get_window()
		if window.mode != Window.MODE_FULLSCREEN:
			window.mode = Window.MODE_FULLSCREEN
		else:
			window.mode = Window.MODE_WINDOWED

func Prepare():
	$"/root/Ui".show()
	$"/root/Ui/Joystick".show()
	$"/root/Ui/DialogueLayer".hide()
	for child in $"/root/Ui/Hearts".get_children():
		child.modulate = Color(1, 1, 1, 1)
	isCat = false
	inputAllowed = true
	hearts = 9
