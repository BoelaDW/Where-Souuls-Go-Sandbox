extends MarginContainer



func _ready():
	pass


func _on_Button_pressed():
	passVariables()

func passVariables():
	pass

func _on_Button2_pressed():
	pass


func _on_ButtonRandom_pressed():
	randomize()
	GLOBAL.worldGenSeed = rand_range(1,9999)
	GLOBAL.worldGenSize = int(rand_range(200, 1000))
	GLOBAL.klaraModeEnabled = $HBoxContainer/VBoxContainer/CBKlaraMode.pressed
	GLOBAL.blockPlacementDebug = $HBoxContainer/VBoxContainer2/CheckButton.pressed
	
	GLOBAL.playerHP = 100
	GLOBAL.playerCanMove = 1
	
	GLOBAL.goto_scene("res://World.tscn")


func _on_ButtonGenerate_pressed():
		
	GLOBAL.worldGenSeed = $HBoxContainer/VBoxContainer/SBSeed.value
	GLOBAL.worldGenSize = $HBoxContainer/VBoxContainer/SBWorldSize.value
	GLOBAL.klaraModeEnabled = $HBoxContainer/VBoxContainer/CBKlaraMode.pressed
	GLOBAL.blockPlacementDebug = $HBoxContainer/VBoxContainer2/CheckButton.pressed
	
	
	GLOBAL.playerHP = 100
	GLOBAL.playerCanMove = 1
	
	
	GLOBAL.goto_scene("res://World.tscn")
	
