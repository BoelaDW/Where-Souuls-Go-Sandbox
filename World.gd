extends Node2D

#export var worldSeed = 10
var worldSeed = GLOBAL.worldGenSeed

#Building block scenes
onready var BLOCK_1_SCENE = 		preload("res://Blocks/Block1.tscn") #Grey blocks
onready var BLOCK_2_SCENE = 		preload("res://Blocks/Block2.tscn") #Blue bricks
onready var BLOCK_2_CORNER_SCENE = 	preload("res://Blocks/Block2Corner.tscn")
onready var BLOCK_2_BACKGROUND = 	preload("res://Blocks/Block2Background.tscn")
onready var BLOCK_3_SCENE = 		preload("res://Blocks/Block3.tscn") #Wooden blocks
onready var BLOCK_3_CORNER_SCENE = 	preload("res://Blocks/Block3Corner.tscn")

#Building related scenes
onready var BUILDING_BASE_SCENE = 	preload("res://Buildings/BuildingBase.tscn")
onready var BUILDING_DOOR = 		preload("res://Buildings/BuildingDoor.tscn")

#Player scene, if that wasn't obvious
onready var PLAYER_SCENE = 			preload("res://Player/Player.tscn")

#Just something to add a little more souul to the game ;D
onready var DECORATION_SCENE = 		preload("res://Objects/Decoration.tscn")
onready var CAMPFIRE_SCENE = 		preload("res://Objects/Campfire.tscn")


#NPCs
onready var ENEMY_1_SCENE = 		preload("res://NPCs/BasicEnemy.tscn")
onready var FRIENDLY_SCENE = 		preload("res://NPCs/Friendly/Friendly.tscn")
onready var EVIL_MAGE_SCENE = 		preload("res://NPCs/EvilMage/EvilMage.tscn")
onready var MEGA_EAGLE_SCENE = 		preload("res://NPCs/MegaEagle.tscn")


#This valuse will be set via the world gen menu
#export var worldWidth = 100
var worldWidth = GLOBAL.worldGenSize

#Used for placing blocks
var blockX = 0
var blockY = 0

#Is there gonna be a fortress?
var spawnFortress = false
var fortressSpawned = false

#For Testing purposes
var amountOfBuildings = 0


func _ready():
	#Seed for world generation
	seed(worldSeed)
	
	#This is to determine if a fortress should be spawned
	var spawnFortressProbability = rand_range(-10,10)
	if spawnFortressProbability > -10:
		spawnFortress = true
	else:
		spawnFortress = false
	
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
	spawnMegaEagle()
	#Friendlies are now spawned with buildings
	
	#Klara mode turns all skeletons and stuff off
	if not GLOBAL.klaraModeEnabled:
		spawnEnemies()




#Just generates the basic floor of the world
func buildFloor():
	
	
	
	for column in range(worldWidth):
		
		var block1 = BLOCK_1_SCENE.instance()
		block1.canBreak = false
		add_child(block1)
		block1.global_position.x = blockX
		block1.global_position.y = blockY
		blockX += block1.blockWidth
		block1.addToDB()
	




#This runs through the entire width of the level and has buildings generated
#The generating is done through another function, this just tells it where
func addBuildings():
	blockX = 0
	var lastBuildingPos = Vector2()
	
	#This is so nothing gets placed on the outside edge of the world
	var leftAndRightBufferSize = 16 * 32
	
	for column in range(worldWidth):
		var buildRandi = randi()%200
		blockX += 16
		if blockX > (lastBuildingPos.x + leftAndRightBufferSize * 1.2) and blockX < (worldWidth * 16) - leftAndRightBufferSize * 1.2:
			if buildRandi < 10:
				lastBuildingPos = Vector2(blockX,blockY)
				generateStructure(blockX,blockY)
				spawnFriendlies(Vector2(blockX,blockY))
				amountOfBuildings += 1
			
		elif blockX > (worldWidth * 16) - (leftAndRightBufferSize + 16) and blockX < (worldWidth*16) - leftAndRightBufferSize / 2:
			if spawnFortress and not fortressSpawned:
				fortressSpawned = true
				lastBuildingPos = Vector2(blockX,blockY)
				generateFortress(blockX,blockY)
				amountOfBuildings += 1
				
				
			
			






#Spawn player in the exact middle of the generated world
func spawnPlayer():
	
	var spawnPosX = (worldWidth * 16) / 2 #Can be changed to worldWidth * 8 for simplicity
	var player = PLAYER_SCENE.instance()
	add_child(player)
	player.global_position = Vector2(spawnPosX,-64)
	


func spawnMegaEagle():
	
	var eagle = MEGA_EAGLE_SCENE.instance()
	add_child(eagle)
	eagle.global_position = Vector2(-512, -256)
	
	
	
	







func spawnFriendlies(baseLocation):
	
	
	var amountOfFriendlies = 0
	var loc = baseLocation
	
	
	if amountOfFriendlies < (worldWidth / 50):
		var friendly = FRIENDLY_SCENE.instance()
		var randDir = rand_range(-5,5)
		if randDir < 0:
			randDir = -1
		else:
			randDir = 1
		friendly.dir = randDir
		add_child(friendly)
		friendly.global_position = Vector2(loc.x - 32,loc.y - 16)
		amountOfFriendlies += 1
		
	


func spawnEnemies():
	
	blockX = 0
	
	for column in range(worldWidth):
		var buildRandi = randi()%int(worldWidth)
		blockX += 16
		if buildRandi < 10 and blockX < (worldWidth * 16) - 64:
			var enemy = ENEMY_1_SCENE.instance()
			add_child(enemy)
			enemy.global_position = Vector2(blockX,blockY - 16)
	
	





func generateFortress(baseX, baseY):
	
	
	#Start from base
	var bbBaseX = baseX
	var bbBaseY = baseY - 16 #-16 is because of block size
	
	#make new variables that will be changed more frequently
	var buildingBlockX = bbBaseX
	var buildingBlockY = bbBaseY
	
	
	var buildingBase = BUILDING_BASE_SCENE.instance()
	add_child(buildingBase)
	buildingBase.global_position = Vector2(baseX,baseY)
	
	#Random Size
	var houseWidth = rand_range(20,30)
	houseWidth = int(houseWidth)
	var houseHeight = rand_range(6,10) #This will be the amount of floors.... Did a little math to make nice size floors
	houseHeight = (int(houseHeight) * 4) - 1
	
	var numberOfFLoors = int(houseHeight / 4)
	var lastFloorY = baseY
	var floorsPlaced = 0
	
	#Generate base of building.
	for row in range(houseHeight):
		
		
		for column in range(houseWidth):
			#Left of house
			if column == 0:
				var block = BLOCK_2_SCENE.instance()
				block.blockHp = 3
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				block.addToDB()
				
			#Right of house
			elif column == houseWidth - 1:
				var block = BLOCK_2_SCENE.instance()
				block.blockHp = 3
				block.flippedH = true
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				block.addToDB()
				
				
			#all the normal blocks
			else:
				#Floors
				if buildingBlockY == lastFloorY - (16 * 4) and floorsPlaced < numberOfFLoors and not column == (houseWidth / 2) and not column == (houseWidth / 2 - 1):
					var block = BLOCK_3_SCENE.instance()
					buildingBase.add_child(block)
					block.global_position = Vector2(buildingBlockX,buildingBlockY)
					if column == houseWidth - 2:
						lastFloorY = buildingBlockY
					block.addToDB()
					numberOfFLoors += 1
				else:
					#Adding Background
					var block = BLOCK_2_BACKGROUND.instance()
					buildingBase.add_child(block)
					block.global_position = Vector2(buildingBlockX,buildingBlockY)
					
					
					
					
					
					#Spawning mages inside
					var randomizeMageSpawn = int(rand_range(-10,10))
					
					
					if randomizeMageSpawn > 0 and (column == 4 and buildingBlockY == lastFloorY - (16) and row > houseHeight / 2) or  randomizeMageSpawn > 0 and (column == houseWidth - 2 and buildingBlockY == lastFloorY - (16 * 2) and row > houseHeight / 3):
						var mage = EVIL_MAGE_SCENE.instance()
						mage.guard = true
						get_parent().add_child(mage)
						mage.global_position = Vector2(buildingBlockX,buildingBlockY)
						
					elif (column == houseWidth - 4 and row == 4):
						
						var campfire = CAMPFIRE_SCENE.instance()
						
						get_parent().add_child(campfire)
						campfire.global_position = Vector2(buildingBlockX,buildingBlockY + 18)
						
						
						
					
					
				
			
			
			
			
			buildingBlockX += 16
		buildingBlockX = bbBaseX
		buildingBlockY -= 16 #Block height
		
	
	
	#Generate roof
	buildingBlockX = bbBaseX - (16* 2)
	for column in range(houseWidth + 4):
		#Left corner
		if column == 0:
			var block = BLOCK_2_SCENE.instance()
			block.blockHp = 3
			block.flippedH = true
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			block.addToDB()
			
		#Right corner
		elif column == houseWidth - 1:
			var block = BLOCK_2_SCENE.instance()
			block.blockHp = 3
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			block.addToDB()
		#All other blocks
		else:
			if column != 6 and column != 7:
				var block = BLOCK_2_SCENE.instance()
				block.blockHp = 3
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				block.addToDB()
			else:
				
				var block = BLOCK_2_BACKGROUND.instance()
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				
				
				
			
		buildingBlockX += 16
	buildingBlockX = bbBaseX - (16 * 3)
	buildingBlockY -= 16
	
	
	#Generate Castle merlons
	for column in range(houseWidth + 4):
		#Left corner
		if column == 1:
			var block = BLOCK_2_SCENE.instance()
			block.blockHp = 3
			block.flippedH = true
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			block.addToDB()
			
		#Right corner
		elif column == houseWidth + 3:
			var block = BLOCK_2_SCENE.instance()
			block.blockHp = 3
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX + 16,buildingBlockY)
			block.addToDB()
		#All other blocks
		else:
			pass
			
			
		buildingBlockX += 16
		
	
	
	
	
	pass






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
				block.addToDB()
				pass
			#Right of house
			elif column == houseWidth - 1:
				var block = BLOCK_3_CORNER_SCENE.instance()
				block.flippedH = true
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				block.addToDB()
				pass
			#all the normal blocks
			else:
				var block = BLOCK_3_SCENE.instance()
				buildingBase.add_child(block)
				block.global_position.x = buildingBlockX
				block.global_position.y = buildingBlockY
				block.addToDB()
				
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
			block.addToDB()
			
			
		elif column == houseWidth - 1:
			var block = BLOCK_2_CORNER_SCENE.instance()
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			block.addToDB()
		else:
			var block = BLOCK_2_SCENE.instance()
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			block.addToDB()
			
			
		buildingBlockX += 16
		
	#Add windows




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
	
