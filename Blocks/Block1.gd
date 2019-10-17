extends StaticBody2D
class_name Block


const blockExtents = 8

var blockWidth = blockExtents * 2
var flippedH = false
var flippedV = false
var canBreak = true

var blockHp = 1


var blockIsCorner = false
var cornerShape = []


var blockId = 0

onready var EXPLODE_SCENE = preload("res://Effects/ProjectileHitEffect.tscn")


func _ready():
	$Sprite.flip_h = flippedH
	
	
	if blockIsCorner:
		if flippedH:
			cornerShape = [Vector2(8,-8),Vector2(8,8),Vector2(-8,8)]
		else:
			cornerShape = [Vector2(-8,-8),Vector2(8,8),Vector2(-8,8)]
		
		
		
		
		var cornerCollisionShape = ConvexPolygonShape2D.new()
		cornerCollisionShape.points = PoolVector2Array(cornerShape)
		$CollisionShape2D.shape = cornerCollisionShape
	
	
	

func destroy(dmg = 1,canBreakBlocks = true):
	if canBreakBlocks:
		blockHp -= dmg
	if canBreak and blockHp <= 0:
		
		
		GLOBAL.blockDB.erase(blockId)
		while GLOBAL.blockDB.has(blockId):
			GLOBAL.blockDB.erase(blockId)
		queue_free()
		
	


func addToDB():
	var pos = Vector2(stepify(self.global_position.x,16), stepify(self.global_position.y,16))
	GLOBAL.blockDB.insert(GLOBAL.blockDB.size(),pos)
	blockId = pos
	
	

func explode():
	var explosion = EXPLODE_SCENE.instance()
	get_parent().add_child(explosion)
	explosion.global_position = self.global_position
	
	
	
	
	queue_free()
	
	
	

func _on_VisibilityNotifier2D_screen_entered():
	$Sprite.visible = true


func _on_VisibilityNotifier2D_screen_exited():
	$Sprite.visible = false
