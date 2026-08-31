extends Node2D

var transitioning := false
var wasCat := false

func _ready() -> void:
	$"/root/Ui".show()
	$"/root/Ui/DialogueLayer".hide()
	Globals.hearts = 9
	$Temple/Event.body_entered.connect(func(body):
		if body.is_in_group("player"):
			Globals.inputAllowed = false
			if Globals.isCat:
					$"Bai Ling".toggleCat()
			$"Bai Ling".lastDirection = 1
			$"Bai Ling".velocity.x = $"Bai Ling".SPEED)

func _process(delta: float) -> void:
	if $"Bai Ling".global_position.y > 680:
		if $Shade.color.a8 < 255 and not transitioning:
			transitioning = true
			transition()
	if not Globals.isCat and not wasCat:
		
		$"Tutorial Text/non solid".hide()
		$"Tutorial Text/transform".show()
		$"Tutorial Text/shoot".hide()
		
	if not wasCat and Globals.isCat:
		wasCat = true
		$"Tutorial Text/shoot".show()
		$"Tutorial Text/transform".hide()
	
	if wasCat and not Globals.isCat:
		$"Tutorial Text/shoot".hide()
		$"Tutorial Text/non solid".show()

func transition():
	$"/root/Ui".hide()
	$RainParticles.emitting = false
	while $Shade.color.a8 < 255:
		$Shade.color.a8 += 2
		await get_tree().create_timer(0.001).timeout
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://scenes/Prologue Cutscene.tscn")
