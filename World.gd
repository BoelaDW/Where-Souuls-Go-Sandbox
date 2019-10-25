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
onready var BLOCK_3_BACKGROUND = 	preload("res://Blocks/Block3Background.tscn")
onready var LADDER_BLOCK = 			preload("res://Blocks/LadderBlock.tscn")#Ladder

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
onready var EVIL_BUILDER_SCENE = 	preload("res://NPCs/EvilBuilder/EvilBuilder.tscn")
onready var ALBERT_BONES_SCENE = 	preload("res://NPCs/BonesTrio/Albert.tscn")


#Debugging block placement
onready var DEBUG_DOT_SCENE = 		preload("res://Debug/DebugDot.tscn")


#Different placed block hp
var fortressBrickHp = 5
var fortressWoodHp = 2



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
	worldWidth = stepify(worldWidth,16)
	print(worldWidth)
	spawnFortress = true
	
	blockY = stepify(get_viewport_rect().size.y - 16,16)
	
	#This generates the world we will play in
	buildWorld()
	


func _input(event):
	#Go back to the menu
	if Input.is_action_just_pressed("ui_cancel"):
		GLOBAL.goto_scene("res://WorldGenerateMenu.tscn")
		
		
	
	if Input.is_action_just_pressed("8") and GLOBAL.blockPlacementDebug:
		debugBlockPlacement()
	
	if Input.is_action_just_pressed("7") and GLOBAL.blockPlacementDebug:
		get_node("/root/World/DebugDot").queue_free()





func debugBlockPlacement():
	var dotBase = DEBUG_DOT_SCENE.instance()
	add_child(dotBase)
	dotBase.global_position = Vector2(0,0)
	for i in GLOBAL.blockDB:
		
		var dot = DEBUG_DOT_SCENE.instance()
		dotBase.add_child(dot)
		dot.global_position = i
		
	
	













#Main Function for generating the world
func buildWorld():
	
	blockX = 0
	buildFloor()
	buildTerrain()
	addBuildings()
	addDecorations()
	spawnPlayer()
	
	#Friendlies are now spawned with buildings
	
	#Klara mode turns all skeletons and stuff off
	if not GLOBAL.klaraModeEnabled:
		#spawnEnemies()
		spawnMegaEagle()


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
		
		
	blockY -= 16

#This will generate hills and other things for the terrain
func buildTerrain():
	
	var baseBlockY = blockY
	var baseBlockX = blockX
	
	blockX = 0
	
	
	var chunkSize = int(worldWidth / 16)
	var terrainHeight = int(rand_range(5,10))
	
	var minTerrainHeight = terrainHeight - 5
	var maxTerrainHeight = terrainHeight + 5
	
	
	var lastBlockX = 0
	
	
	
	
	
	for column in range(worldWidth):
		
		if blockX >= lastBlockX + 64:
			if terrainHeight <= minTerrainHeight:
				terrainHeight += 1
			elif terrainHeight >= maxTerrainHeight:
				terrainHeight -= 1
			else:
				terrainHeight += int(rand_range(-2,2))
			lastBlockX = blockX
		
		
		
		
		
		
		
		for row in range(terrainHeight):
			
			if not GLOBAL.blockDB.has(Vector2(blockX,blockY)):
				var block = BLOCK_2_SCENE.instance()
				add_child(block)
				
				block.global_position = Vector2(blockX,blockY)
				block.addToDB()
				
				
			blockY = stepify(blockY,16)
			
			
			blockY -= 16
		
		blockY = baseBlockY
		blockX += 16
	blockX = 0
	
	
	blockY = baseBlockY - 64



func generateCaves(caveBaseX = 0, caveBaseY = 0):
	
	var caveHeight = int(rand_range(3,5))
	var caveWidth = int(rand_range(3,7))
	
	var caveBlockX = caveBaseX
	var caveBlockY = caveBaseY - 16
	
	
	var cave = [Vector2()]
	
	for row in range(caveHeight):
		for column in range(caveWidth):
			
			cave[1] = Vector2(caveBlockX,caveBlockY) 
			
			caveBlockX += 16
		caveBlockY -= 16
		caveBlockX = caveBaseX
	
	for block in cave:
		GLOBAL.blockDB.insert(GLOBAL.blockDB.size(),Vector2(caveBlockX,caveBlockY))
		
	
	#var pos = Vector2(stepify(self.global_position.x,16), stepify(self.global_position.y,16))
	#GLOBAL.blockDB.insert(GLOBAL.blockDB.size(),pos)
	#blockId = pos
	
	





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
			if not GLOBAL.klaraModeEnabled and spawnFortress and not fortressSpawned:
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
		friendly.housePos = loc
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
			#Left of fort
			if column == 0:
				var block = BLOCK_2_SCENE.instance()
				block.blockHp = fortressBrickHp
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				block.addToDB()
				
			#Right of fort
			elif column == houseWidth - 1:
				var block = BLOCK_2_SCENE.instance()
				block.blockHp = fortressBrickHp
				block.flippedH = true
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				block.addToDB()
				
				
			#all the normal blocks
			else:
				
				if not GLOBAL.blockDB.has(Vector2(buildingBlockX,buildingBlockY)) and  column == (houseWidth / 2) or  not GLOBAL.blockDB.has(Vector2(buildingBlockX,buildingBlockY)) and column == (houseWidth / 2 - 1):
					var ladder = LADDER_BLOCK.instance()
					buildingBase.add_child(ladder)
					ladder.global_position = Vector2(buildingBlockX,buildingBlockY)
					ladder.addToDB()
					
					
					
				
				
				
				
				
				if buildingBlockY == lastFloorY - (16 * 4) and floorsPlaced < numberOfFLoors and not column == (houseWidth / 2) and not column == (houseWidth / 2 - 1):
					var block = BLOCK_3_SCENE.instance()
					block.blockHp = fortressWoodHp
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
					var randomizeMageSpawn = int(rand_range(-5,10))
					
					
					if randomizeMageSpawn > 0 and (column == 4 and buildingBlockY == lastFloorY - (16) and row > houseHeight / 2) or  randomizeMageSpawn > 0 and (column == houseWidth - 2 and buildingBlockY == lastFloorY - (16 * 2) and row > houseHeight / 3):
						var mage = EVIL_MAGE_SCENE.instance()
						mage.guard = true
						get_parent().add_child(mage)
						mage.global_position = Vector2(buildingBlockX,buildingBlockY)
						
					elif randomizeMageSpawn < 0 and (column == 4 and buildingBlockY == lastFloorY - (16) and row > houseHeight / 2) or  randomizeMageSpawn > 0 and (column == houseWidth - 2 and buildingBlockY == lastFloorY - (16 * 2) and row > houseHeight / 3):
						var builder = EVIL_BUILDER_SCENE.instance()
						get_parent().add_child(builder)
						builder.global_position = Vector2(buildingBlockX,buildingBlockY)
						
						
						
					
					if (column == houseWidth - 4 and row == 4):
						
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
			block.blockHp = fortressBrickHp
			block.flippedH = true
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			block.addToDB()
			
		#Right corner
		elif column == houseWidth - 1:
			var block = BLOCK_2_SCENE.instance()
			block.blockHp = fortressBrickHp
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			block.addToDB()
		#All other blocks
		else:
			if column != 6 and column != 7:
				var block = BLOCK_2_SCENE.instance()
				block.blockHp = fortressBrickHp
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
		elif column == houseWidth - 6:
			var albertScene = ALBERT_BONES_SCENE.instance()
			add_child(albertScene)
			albertScene.global_position = Vector2(buildingBlockX, buildingBlockY + 16)
			
			
			
			
			
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
	var houseHeight = int(rand_range(1, 4)) * 4
	houseHeight = int(houseHeight) - 1
	
	var numberOfFLoors = int(houseHeight / 4)
	var lastFloorY = baseY
	var floorsPlaced = 0
	
	
	
	#Generate base of building.
	for row in range(houseHeight):
		for column in range(houseWidth):
			
			#Left of house
			if not GLOBAL.blockDB.has(Vector2(buildingBlockX,buildingBlockY)) and  column == 0 and not row == 0:
				var block = BLOCK_3_CORNER_SCENE.instance()
				
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				block.addToDB()
				pass
			#Right of house
			elif not GLOBAL.blockDB.has(Vector2(buildingBlockX,buildingBlockY)) and  column == houseWidth - 1 and not row == 0:
				var block = BLOCK_3_CORNER_SCENE.instance()
				block.flippedH = true
				buildingBase.add_child(block)
				block.global_position = Vector2(buildingBlockX,buildingBlockY)
				block.addToDB()
				pass
			#all the normal blocks
			else:
				#Floors
				if (not GLOBAL.blockDB.has(Vector2(buildingBlockX,buildingBlockY)) and buildingBlockY == lastFloorY - (16 * 4) and floorsPlaced < numberOfFLoors) and not column == 1 and not column == 2:
					var block = BLOCK_3_SCENE.instance()
					buildingBase.add_child(block)
					block.global_position = Vector2(buildingBlockX,buildingBlockY)
					if column == houseWidth - 2:
						lastFloorY = buildingBlockY
					block.addToDB()
					numberOfFLoors += 1
				else:
					#Adding Background
					var block = BLOCK_3_BACKGROUND.instance()
					buildingBase.add_child(block)
					block.global_position = Vector2(buildingBlockX,buildingBlockY)
					
				
			
			
			buildingBlockX += 16
		buildingBlockX = bbBaseX
		buildingBlockY -= 16 #Block height
	#Generate roof
	for column in range(houseWidth):
		if column == 0:
			var block = BLOCK_2_CORNER_SCENE.instance()
			block.blockIsCorner = true
			block.flippedH = true
			buildingBase.add_child(block)
			block.global_position = Vector2(buildingBlockX,buildingBlockY)
			block.addToDB()
			
			
		elif column == houseWidth - 1:
			var block = BLOCK_2_CORNER_SCENE.instance()
			block.blockIsCorner = true
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
	
