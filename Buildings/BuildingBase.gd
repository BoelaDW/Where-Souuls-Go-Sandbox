extends Node2D

#This will be set when the house is generated
var houseSize = Vector2(100,100)
onready var CLEAR_BLOCK_SCENE = preload("res://Buildings/ClearBlockArea.tscn")



#Add block removing area
func removeBlocks():
	
	var clearBlocksArea = CLEAR_BLOCK_SCENE.instance()
	add_child(clearBlocksArea)
	clearBlocksArea.setSize(houseSize)
	
