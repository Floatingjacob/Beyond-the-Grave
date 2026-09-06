extends TextureButton

@export var Text:String

func _process(_delta: float) -> void:
	if $text.text != Text:
		$text.text = Text
	if is_hovered():
		$text.show()
	else:
		$text.hide()
