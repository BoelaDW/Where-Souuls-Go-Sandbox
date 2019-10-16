extends StaticBody2D
class_name BuildingDoor

var hp = 1

onready var EXPLODE_SCENE = preload("res://Effects/ProjectileHitEffect.tscn")

func _ready():
	pass


func _on_Area2D_body_entered(body):
	pass





func destroy(dmg = 1,canDestroyBlocks = true):
	if canDestroyBlocks:
		hp -= dmg
	if hp <= 0:
		
		
		queue_free()
	