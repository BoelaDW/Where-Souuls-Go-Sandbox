extends Node2D

#export var worldSeed = 10
var worldSeed = GLOBAL.worldGenSeed

#Building block scenes
onready var BLOCK_1_SCENE = preload("res://Blocks/Block1.tscn")
onready var BLOCK_2_SCENE = preload("res://Blocks/Block2.tscn")
onready var BLOCK_2_CORNER_SCENE = preload("res://Blocks/Block2Corner.tscn")
onready var BLOCK_3_SCENE = preload("res://Blocks/Block3.tscn")
onready var BLOCK_3_CORNER_SCENE = preload("res://Blocks/Block3Corner.tscn")

#Building related scenes
onready var BUILDING_BASE_SCENE = preload("res://Buildings/BuildingBase.tscn")
onready var BUILDING_DOOR = preload("res://Buildings/BuildingDoor.tscn")

#Player scene, if that wasn't obvious
onready var PLAYER_SCENE = preload("res://Player/Player.tscn")

#Just something to add a little more souul to the game ;D
onready var DECORATION_SCENE = preload("res://Objects/Decoration.tscn")
onready var ENEMY_1_SCENE = preload("res://NPCs/BasicEnemy.tscn")


#This valuse will be set via the world gen menu
#export var worldWidth = 100
var worldWidth = GLOBAL.worldGenSize

#Used for placing blocks
var blockX = 0
var blockY = 0



#For Testing purposes
var amountOfBuildings = 0


func _ready():
	
	
	
	
	seed(worldSeed)
	blockY = stepify(get_viewport_rect().size.y - 16,16)
	
	#This generates the world we will play in
	buildWorld()



func _input(event):
	#Go back to the menu
	if Input.is_action_just_pressed("ui_cancel"):
		GLOBAL.goto_scene("res://WorldGenerateMenu.tscn")
		
	
	
	

#Main Function for generating the world
func buildWorld():
	
	blockX = 0
	buildFloor()
	addBuildings()
	addDecorations()
	spawnPlayer()
	spawnEnemies()
	
	#This is just interesting to see how many buildings were added
	print(amountOfBuildings)

#Spawn player in the exact middle of the generated world
func spawnPlayer():
	
	var spawnPosX = (worldWidth * 16) / 2 #Can be changed to worldWidth * 8 for simplicity
	var player = PLAYER_SCENE.instance()
	add_child(player)
	player.global_position = Vector2(spawnPosX,0)
	
	
	


func spawnEnemies():
	
	
	blockX = 0
	
	
	for column in range(worldWidth):
		var buildRandi = randi()%int(worldWidth)
		blockX += 16
		if buildRandi < 10 and blockX < (worldWidth * 16) - 64:
			var enemy = ENEMY_1_SCENE.instance()
			add_child(enemy)
			enemy.global_position = Vector2(blockX,blockY - 16)
	
	
	
	




#This runs through the entire width of the level and has buildings generated
#The generating is done through another function, this just tells it where
func addBuildings():
	blockX = 0
	var lastBuildingPos = Vector2()
	
	
	for column in range(worldWidth):
		var buildRandi = randi()%200
		blockX += 16
		if buildRandi < 10 and blockX > (lastBuildingPos.x + 256) and blockX < (worldWidth * 16) - 256:
			lastBuildingPos = Vector2(blockX,blockY)
			generateStructure(blockX,blockY)
			amountOfBuildings += 1

func addDecorations():
	
	blockX = 0
	var lastDecorationPos = Vector2()
	
	
	for column in range(worldWidth):
		var buildRandi = randi()%int(worldWidth)
		blockX += 16
		if buildRandi < 10 and blockX > (lastDecorationPos.x + 16) and blockX < (worldWidth * 16) - 64:
			lastDecorationPos = Vector2(blockX,blockY)
			var decoration = DECORATION_SCENE.instance()
			add_child(decoration)
			decoration.global_position = Vector2(blockX,blockY - 8)
	
	
	

#This one generates and builds the random buildings
func generateStructure(baseX,baseY):
	
	#Start from base
	var hasDoor = false
	
	var bbBaseX = baseX
	var bbBaseY = baseY - 16
	
	var buildingBlockX = bbBaseX
	var buildingBlockY = bbBaseY
	
	var buildingBase = BUILDING_BASE_SCENE.instance()
	add_child(buildingBase)
	buildingBase.global_position = Vector2(baseX,baseY)
	
	#Random Size
	var houseWidth = rand_range(6,15)
	houseWidth = int(houseWidth)
	var houseHeight = rand_range(3, 10)
	houseHeight = int(houseHeight)
	
	#Generate base of building.
	for row in range(houseHeight):
		for column in range(houseWidth):
			#Left of house
			if column == 0:
				var block = BLOCK_3_CORNER_SCENE.instance()
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				
				pass
			#Right of house
			elif column == houseWidth - 1:
				var block = BLOCK_3_CORNER_SCENE.instance()
				block.flippedH = true
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				
				pass
			#all the normal blocks
			else:
				var block = BLOCK_3_SCENE.instance()
				buildingBase.add_child(block)
				block.global_position.x = buildingBlockX
				block.global_position.y = buildingBlockY
				
			#adds one door to each building
			if column == houseWidth/3 and hasDoor == false:
				var door = BUILDING_DOOR.instance()
				buildingBase.add_child(door)
				door.global_position = Vector2(buildingBlockX,buildingBlockY)
				hasDoor = true
			
			
			
			buildingBlockX += 16
		buildingBlockX = bbBaseX
		buildingBlockY -= 16 #Block height
	#Generate roof
	for column in range(houseWidth):
		if column == 0:
			var block = BLOCK_2_CORNER_SCENE.instance()
			block.flippedH = true
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			
			
			
		elif column == houseWidth - 1:
			var block = BLOCK_2_CORNER_SCENE.instance()
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			
		else:
			var block = BLOCK_2_SCENE.instance()
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			
			
			
		buildingBlockX += 16
		
	#Add windows

#Just generates the basic floor of the world
func buildFloor():
	
	
	
	for column in range(worldWidth):
		
		var block1 = BLOCK_1_SCENE.instance()
		block1.canBreak = false
		add_child(block1)
		block1.global_position.x = blockX
		block1.global_position.y = blockY
		blockX += block1.blockWidth
	
	