extends Node
signal e
var oldText = ""

@export var TypingInterval:float = 0.05
@export var QuickPauseInterval:float = 0.75
@export var typingSound:AudioStream

var config = ConfigFile.new()
var skip := false
var timer:SceneTreeTimer

func _ready() -> void:
	await get_tree().process_frame
	timer = get_tree().create_timer(0)
	if config.load("user://misc.cfg") == OK:
		TypingInterval = config.get_value("typing", "speed")

func fancyType(newText: String, clearOldText: bool, textContainer: RichTextLabel = $text):
	$TypingSound.stream = typingSound
	skip = false
	Globals.dialogueOpen = true
	if clearOldText:
		textContainer.clear()
		textContainer.text = ""
		textContainer.visible_characters = 0
		oldText = ""

	oldText += newText
	textContainer.append_text(newText)
	
	while textContainer.visible_characters < textContainer.get_total_character_count() and not skip:
		#if get_tree().paused: await PauseOverlay.Unpaused
		textContainer.visible_characters += 1
		$TypingSound.play()
		await get_tree().create_timer(TypingInterval).timeout
	skip = false
	textContainer.text = oldText
	textContainer.visible_characters = textContainer.get_parsed_text().length() # This makes sure all the text is visible if we skip the typing effect
	#await e
	Globals.dialogueOpen = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("UI_INTERACT"): 
		if Globals.dialogueOpen:
			skip = true
		if timer != null:
			timer.timeout.emit()
		e.emit()

func Reset():
	$".".hide()
	e.emit()
	$text.text = ""
	$text.visible_characters = -1
	oldText = ""
	Globals.dialogueOpen = false

func setTypingSound(sound:AudioStream) : typingSound = sound
