extends KinematicBody2D
class_name Player


const INTERPOLATE_SPEED = 10
const WALK_SPEED = 200
const GRAVITY = 10
const JUMP_FORCE = -300
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var dir = -1


var blockPlaceDirX = -1
var blockPlaceDirY = 0

var lPressed = false
var rPressed = false
var uPressed = false
var dPressed = false


var firePosPos = Vector2()
var dummyBlockPos = Vector2()


#Coyote Time
var canJump

var canFire = true

onready var WOOD_BLOCK_SCENE = preload("res://Blocks/Block2.tscn")
onready var PROJECTILE = preload("res://Player/Projectile.tscn")

func _ready():
	$PowerRegenTimer.start()
	add_to_group("Player")
	$AnimationPlayer.play("Active")
	


func getInput():
	
	if Input.is_action_pressed("ui_right"):
		rPressed = true
	else:
		rPressed = false
	
	if Input.is_action_pressed("ui_left"):
		lPressed = true
	else:
		lPressed = false
	
	if Input.is_action_pressed("ui_up"):
		uPressed = true
	else:
		uPressed = false
	
	if Input.is_action_pressed("ui_down"):
		dPressed = true
	else:
		dPressed = false
	
	if Input.is_action_pressed("ui_select") and is_on_floor():
		
		velocity.y = JUMP_FORCE
	
	if Input.is_action_pressed("ui_accept"):
		interactButton()
	
	
	
	
	#Toolbar hotkeys
	if Input.is_action_pressed("1"):
		GLOBAL.selectedToolbarTool = 0
	if Input.is_action_pressed("2"):
		GLOBAL.selectedToolbarTool = 1
	if Input.is_action_pressed("3"):
		GLOBAL.selectedToolbarTool = 2
	if Input.is_action_pressed("4"):
		GLOBAL.selectedToolbarTool = 3
	if Input.is_action_pressed("5"):
		GLOBAL.selectedToolbarTool = 4
	if Input.is_action_pressed("6"):
		GLOBAL.selectedToolbarTool = 5
	if Input.is_action_pressed("7"):
		GLOBAL.selectedToolbarTool = 6
	if Input.is_action_pressed("8"):
		GLOBAL.selectedToolbarTool = 7
	
	
	
	

func interactButton():
	if GLOBAL.selectedToolbarTool == 0  and canFire and GLOBAL.playerPower > 0 and GLOBAL.playerCanMove > 0:
		#FireProjectile
		var projectile = PROJECTILE.instance()
		projectile.dir = dir
		projectile.Ydir = blockPlaceDirY
		projectile.velocity.x += velocity.x
		get_parent().add_child(projectile)
		projectile.global_position = self.global_position
		canFire = false
		$CanFireTimer.start()
		GLOBAL.playerPower -= 5
		shakeCamera()
		
		if GLOBAL.checkCanMoveRight(global_position.x) and GLOBAL.checkCanMoveLeft(global_position.x):
			velocity.x += -dir * 100
		velocity.y += -blockPlaceDirY * 100
		
		
		
		
		
	elif GLOBAL.selectedToolbarTool == 1:
		#PlaceBlock
		if blockPlaceDirX == 1:
			var blockNewPos = Vector2(stepify($FirePosition.global_position.x,16), stepify($FirePosition.global_position.y,16))
			
			if GLOBAL.blockDB.has(blockNewPos):
				pass
			else:
				var blockToPlace = WOOD_BLOCK_SCENE.instance()
				get_parent().add_child(blockToPlace)
				blockToPlace.global_position = blockNewPos
				blockToPlace.addToDB()
		elif blockPlaceDirX == -1:
			var blockNewPos = Vector2(stepify($FirePosition.global_position.x,16), stepify($FirePosition.global_position.y,16))
			
			if GLOBAL.blockDB.has(blockNewPos):
				pass
			else:
				var blockToPlace = WOOD_BLOCK_SCENE.instance()
				get_parent().add_child(blockToPlace)
				blockToPlace.global_position = blockNewPos
				blockToPlace.addToDB()
			
		else:
			
			if blockPlaceDirY == 1:
				var blockNewPos = Vector2(stepify($FirePosition.global_position.x,16), stepify($FirePosition.global_position.y,16))
				
				if GLOBAL.blockDB.has(blockNewPos):
					pass
				else:
					var blockToPlace = WOOD_BLOCK_SCENE.instance()
					get_parent().add_child(blockToPlace)
					blockToPlace.global_position = blockNewPos
					blockToPlace.addToDB()
				
			if blockPlaceDirY == -1:
				var blockNewPos = Vector2(stepify($FirePosition.global_position.x,16), stepify($FirePosition.global_position.y,16))
				
				if GLOBAL.blockDB.has(blockNewPos):
					pass
				else:
					var blockToPlace = WOOD_BLOCK_SCENE.instance()
					get_parent().add_child(blockToPlace)
					blockToPlace.global_position = blockNewPos
					blockToPlace.addToDB()
				
				
			
			
		
		
		
		
	
	
	
	
	



func testForFallDmg():
	pass
	
	
	

func _physics_process(delta):
	
	
	
	
	
	getInput()
	
	
	
	
	
	if dir == 1:
			$FirePosition.position.x = 8
	elif dir == -1:
		$FirePosition.position.x = -24
	
	if blockPlaceDirY == 1:
		
		$FirePosition.position.y = 16
	elif blockPlaceDirY == -1:
		$FirePosition.position.x = -8
		$FirePosition.position.y = -16
	else:
		$FirePosition.position.y = 0
	
	
	
	
	if GLOBAL.selectedToolbarTool == 1:
		$DummyBlock.visible = true
		
		
		dir = blockPlaceDirX
		
		
		$DummyBlock.global_position = Vector2(stepify($FirePosition.global_position.x,16),stepify($FirePosition.global_position.y,16))
		
		
	else:
		$DummyBlock.visible = false
		
	
	
	if $Area2D.get_overlapping_bodies() != []:
		for body in $Area2D.get_overlapping_bodies():
			if body is Enemy:
				body.attackPlayer()
			
		
		
	
	
	
	
	
	
	
	if global_position.y > 2000:
		GLOBAL.goto_scene("res://WorldGenerateMenu.tscn")
	GLOBAL.playerPos = self.global_position
	
	if rPressed and not lPressed and GLOBAL.checkCanMoveRight(global_position.x):
		
		velocity = velocity.linear_interpolate(Vector2(WALK_SPEED,velocity.y), delta * INTERPOLATE_SPEED)
		$Body.flip_h = true
		$Eyes.flip_h = true
		dir = 1
		blockPlaceDirX = 1
	elif lPressed and not rPressed and GLOBAL.checkCanMoveLeft(global_position.x):
		
		velocity = velocity.linear_interpolate(Vector2(-WALK_SPEED,velocity.y), delta * INTERPOLATE_SPEED)
		$Body.flip_h = false
		$Eyes.flip_h = false
		dir = -1
		blockPlaceDirX = -1
		
	else:
		velocity = velocity.linear_interpolate(Vector2(0,velocity.y), delta * INTERPOLATE_SPEED)
	
	
	if uPressed and not dPressed:
		blockPlaceDirY = -1
		
	elif dPressed and not uPressed:
		blockPlaceDirY = 1
		
	else:
		blockPlaceDirY = 0
	
	
	
	
	
	
	
	
	
	
	velocity.y += GRAVITY
	
	
	#This is so player movement can be disabled when dead
	velocity.y = velocity.y * GLOBAL.playerCanMove
	velocity.x = velocity.x * GLOBAL.playerCanMove
	
	velocity = move_and_slide(velocity,FLOOR)
	

func _on_CanFireTimer_timeout():
	canFire = true





func destroy(dmg = 10,canDestroyBlocks = true):
	GLOBAL.playerHP -= dmg
	velocity.y = -100
	velocity.x = 20 * -dir
	

func heal(heal= 5):
	if GLOBAL.playerHP < 100:
		GLOBAL.playerHP += heal
	
	

var shakeProgress = 0
func shakeCamera():
	
	$ShakeTimer.start()
	shakeProgress += 1
	



func _on_ShakeTimer_timeout():
	if shakeProgress < 5 and shakeProgress > 0:
		$Camera2D.offset = Vector2(randi()%3 * dir,rand_range(-3,3))
		shakeCamera()
	else:
		shakeProgress = 0
		$Camera2D.offset = Vector2()


func _on_PowerRegenTimer_timeout():
	if GLOBAL.playerPower < 100:
		GLOBAL.playerPower += 5
	$PowerRegenTimer.start()
