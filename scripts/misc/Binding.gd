extends Node


func _ready() -> void:
	if Globals.config.load("user://config.cfg") == OK and Globals.config.has_section("controls"):
		for action in Globals.config.get_section_keys("controls"):
			InputMap.action_erase_events(action)
			for event in Globals.config.get_value("controls", action):
				InputMap.action_add_event(action, event)

func GetBind(Action: String) -> String:
	return InputMap.action_get_events(Action)[0].as_text().split(" - ")[0]

func Bind(Action: String, NewKey: InputEventKey):
	InputMap.action_erase_events(Action)
	InputMap.action_add_event(Action, NewKey)
	for action in InputMap.get_actions():
		if action == "UI_INTERACT" || action == "ui_up" || action == "ui_left" || action == "ui_right" || action == "UI_PAUSE" || action == "SKIP":
			Globals.config.set_value("controls", action, InputMap.action_get_events(action))
	Globals.config.save("user://config.cfg")
