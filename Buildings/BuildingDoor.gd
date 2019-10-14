extends StaticBody2D
class_name BuildingDoor



onready var EXPLODE_SCENE = preload("res://Effects/ProjectileHitEffect.tscn")

func _ready():
	pass


func _on_Area2D_body_entered(body):
	pass





func destroy():
	
	queue_free()
	