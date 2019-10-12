extends RigidBody2D
class_name Block


const blockExtents = 8

var blockWidth = blockExtents * 2
var flippedH = false
var flippedV = false
var canBreak = true

onready var EXPLODE_SCENE = preload("res://Effects/ProjectileHitEffect.tscn")


func _ready():
	$Sprite.flip_h = flippedH
	
	#Hopefully this can be used to set them back to rigidBodies at some point
	set_mode(RigidBody2D.MODE_STATIC)

func destroy():
	if canBreak:
		queue_free()
	



func explode():
	var explosion = EXPLODE_SCENE.instance()
	get_parent().add_child(explosion)
	explosion.global_position = self.global_position
	
	
	
	
	queue_free()
	
	
	