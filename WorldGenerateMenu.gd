extends MarginContainer



func _ready():
	pass


func _on_Button_pressed():
	passVariables()

func passVariables():
	
	GLOBAL.worldGenSeed = $HSplitContainer/SeedSB.value
	GLOBAL.worldGenSize = $HSplitContainer/WorldSizeSB.value
	GLOBAL.klaraModeEnabled = $HSplitContainer/KModeCheckButton.pressed
	GLOBAL.goto_scene("res://World.tscn")
	