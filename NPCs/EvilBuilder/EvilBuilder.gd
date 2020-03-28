extends KinematicBody2D
class_name EvilBuilder



var MOVE_SPEED = 50
const JUMP_FORCE = -200
const GRAVITY = 10
const FLOOR = Vector2(0,-1)

var hp = 5


var dir = 1
var velocity = Vector2()

var wandering = false

onready var EXPLODE_EFFECT = preload("res://Effects/BuilderBombEffect.tscn")
onready var BLOCK_SCENE = preload("res://Blocks/Block2.tscn")

func _ready():
	pass


func _physics_process(delta):
	
	
	
	var leftRCCollider = $RCDetectPlayerLeft.get_collider()
	var rightRCCollider = $RCDetectPlayerRight.get_collider()
	
	if dir == 1:
		$BlockPlacePosition.position.x = 16
	elif dir == -1:
		$BlockPlacePosition.position.x = -16
	
	if velocity.x > 0:
		$Sprite.flip_h = true
	elif velocity.x < 0:
		$Sprite.flip_h = false
	
	
	#If mage is on one side and player is on the other, build a wall
	if leftRCCollider is Player and rightRCCollider is EvilMage:
		dir = 0
		placeBlock()
		
	if rightRCCollider is Player and leftRCCollider is EvilMage:
		
		dir = 0
		placeBlock()
	
	
	
	#If Builder is close enough to the Player, explode
	if (leftRCCollider == null or leftRCCollider is Block) and rightRCCollider is Player:
		dir = 1
		if GLOBAL.playerPos.x <= self.global_position.x + 16 * 2:
			explode()
			
		
	if (rightRCCollider == null or rightRCCollider is Block) and leftRCCollider is Player:
		dir = -1
		if GLOBAL.playerPos.x >= self.global_position.x - 16 * 2:
			explode()
			
	
	
	#Turn when hitting a wall
	if $RCBlockDetectLeftTop.is_colliding() and not $RCDetectPlayerLeft.get_collider() is Player:
		dir = 1
	
	if $RCBlockDetectRightTop.is_colliding() and not $RCFloorCheckLeft.get_collider() is Player:
		dir = -1
	
	if $RCBlockDetectRightBottom2.is_colliding() and not $RCBlockDetectRightTop.is_colliding() and dir == 1:
		if is_on_floor():
			velocity.y = JUMP_FORCE
	
	
	if $RCBlockDetectLeftBottom.is_colliding() and not $RCBlockDetectLeftTop.is_colliding() and dir == -1:
		if is_on_floor():
			velocity.y = JUMP_FORCE
	
	
	
	velocity.y += GRAVITY
	
	velocity.x = MOVE_SPEED * dir
	
	velocity = move_and_slide(velocity,FLOOR)


func destroy(dmg = 5):
	
	hp -= dmg
	if hp <= 0:
		explode()
	
	



func explode():
	if $Area2D.get_overlapping_bodies() != []:
		for body in $Area2D.get_overlapping_bodies():
			if body is Player or body is Block or body is EvilMage or body is Friendly:
				
				body.destroy(80)
				
			
			
	get_node(GLOBAL.playerPath).shakeCamera(10)
	
	var explodeEffect = EXPLODE_EFFECT.instance()
	get_parent().add_child(explodeEffect)
	explodeEffect.global_position = self.global_position
	queue_free()
	
	
	
	




func placeBlock():
	
	var blockNewPos = Vector2(stepify($BlockPlacePosition.global_position.x,16), stepify($BlockPlacePosition.global_position.y,16))
	var block1NewPos = Vector2(stepify($BlockPlacePosition.global_position.x,16), stepify($BlockPlacePosition.global_position.y -16,16))
	
	
	if GLOBAL.blockDB.has(blockNewPos):
		pass
	else:
		var blockToPlace = BLOCK_SCENE.instance()
		get_parent().add_child(blockToPlace)
		blockToPlace.global_position = blockNewPos
		blockToPlace.addToDB()
		
		var blockToPlace1 = BLOCK_SCENE.instance()
		get_parent().add_child(blockToPlace1)
		blockToPlace1.global_position = block1NewPos
		blockToPlace1.addToDB()
	
	


func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)


func _on_VisibilityNotifier2D_screen_exited():
	set_physics_process(false)
