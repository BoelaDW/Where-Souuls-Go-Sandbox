extends Area2D
class_name BreakableDoor
func _ready():
	pass


func destroy():
	queue_free()
	