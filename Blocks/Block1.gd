extends RigidBody2D
class_name Block


const blockExtents = 8

var blockWidth = blockExtents * 2
var flippedH = false
var flippedV = false
var canBreak = true

var blockHp = 1


var blockId = 0

onready var EXPLODE_SCENE = preload("res://Effects/ProjectileHitEffect.tscn")


func _ready():
	$Sprite.flip_h = flippedH
	#Hopefully this can be used to set them back to rigidBodies at some point
	set_mode(RigidBody2D.MODE_STATIC)

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
	$CollisionShape2D.disabled = false


func _on_VisibilityNotifier2D_screen_exited():
	$Sprite.visible = false
	$CollisionShape2D.disabled = true
