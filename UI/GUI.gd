extends MarginContainer

func _ready():
	pass


func _physics_process(delta):
	
	$GridContainer/VBoxLT/HPBar.value = GLOBAL.playerHP
	$GridContainer/VBoxLT/PowerBar.value = GLOBAL.playerPower
	
	updateToolbar()
	checkIfIsDead()

func checkIfIsDead():
	if GLOBAL.playerHP <= 1:
		#Dead
		GLOBAL.playerCanMove = 0
		$GridContainer.visible = false
		$DeathMenu.visible = true
		
	
	
	
	




func updateToolbar():
	
	var selectedTool = GLOBAL.selectedToolbarTool
	
	if selectedTool == 0:
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem1/SelectedColor.visible = true
		
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem2/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem3/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem4/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem5/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem6/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem7/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem8/SelectedColor.visible = false
	elif selectedTool == 1:
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem2/SelectedColor.visible = true
		
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem1/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem3/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem4/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem5/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem6/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem7/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem8/SelectedColor.visible = false
		
	elif selectedTool == 2:
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem3/SelectedColor.visible = true
		
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem1/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem2/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem4/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem5/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem6/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem7/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem8/SelectedColor.visible = false
		
	elif selectedTool == 3:
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem4/SelectedColor.visible = true
		
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem1/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem2/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem3/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem5/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem6/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem7/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem8/SelectedColor.visible = false
		
	elif selectedTool == 4:
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem5/SelectedColor.visible = true
		
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem1/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem2/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem3/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem4/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem6/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem7/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem8/SelectedColor.visible = false
		
	elif selectedTool == 5:
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem6/SelectedColor.visible = true
		
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem1/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem2/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem3/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem4/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem5/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem7/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem8/SelectedColor.visible = false
		
	elif selectedTool == 6:
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem7/SelectedColor.visible = true
		
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem1/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem2/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem3/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem4/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem5/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem6/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem8/SelectedColor.visible = false
		
	elif selectedTool == 7:
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem8/SelectedColor.visible = true
		
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem1/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem3/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem4/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem5/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem6/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem7/SelectedColor.visible = false
		$GridContainer/VBoxLT/HBoxContainer/ToolBarItem2/SelectedColor.visible = false
		
	
	
	

func _on_ToolBarItem1_mouse_entered():
	GLOBAL.selectedToolbarTool = 0


func _on_ToolBarItem2_mouse_entered():
	GLOBAL.selectedToolbarTool = 1


func _on_Button_pressed():
	GLOBAL.goto_scene("res://WorldGenerateMenu.tscn")
