extends CanvasLayer

var touch := false

func _ready() -> void:
	var os = OS.get_name()
	if os == "iOS" or os == "Android":
		touch = true
	#$Defend.pressed.connect(func():Input.action_press("dodge"))
	#$Defend.released.connect(func():Input.action_release("dodge"))
	#$Transform.pressed.connect(func():Input.action_press("toggle_cat"))
	#$Transform.released.connect(func():Input.action_release("toggle_cat"))
	
func _input(event: InputEvent) -> void:
	if Globals.inputAllowed:
		touch = event is InputEventScreenTouch or event is InputEventScreenDrag

func _process(_delta: float) -> void:
	if touch:
		$"/root/Ui/Transform".show()
		$"/root/Ui/Defend".show()
		$"/root/Ui/Joystick".show()
	else:
		$"/root/Ui/Transform".hide()
		$"/root/Ui/Defend".hide()
		$"/root/Ui/Joystick".hide()
	$"/root/Ui/Defend".visible = !Globals.isCat and touch

func updateHeartDisplay(newHearts:int, maxHearts:int):
	var i = 0
	
	for child in $"Hearts".get_children():
		child.modulate = Color(1, 1, 1, 0)
		
	for child in $"Hearts".get_children():
		if i < maxHearts:
			i += 1
			child.modulate = Color(1, 1, 1, 0.5)
		else: break
		
	i = 0
		
	for child in $"Hearts".get_children():
		if i < newHearts:
			i += 1
			child.modulate = Color(1, 1, 1, 1)
		else: break
