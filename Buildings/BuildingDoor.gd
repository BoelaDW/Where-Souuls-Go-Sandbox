extends Node2D
class_name BuildingDoor

func _ready():
	pass


func _on_Area2D_body_entered(body):
	pass


func destroy():
	queue_free()
	