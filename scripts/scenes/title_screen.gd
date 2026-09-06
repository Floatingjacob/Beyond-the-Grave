extends Node2D

func _ready() -> void:
	await get_tree().process_frame
	Ui.hide()
	$"/root/Ui/Joystick".hide()
	$"/root/Ui/DialogueLayer".hide()
