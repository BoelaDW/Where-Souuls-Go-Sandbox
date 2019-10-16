extends Control

func _ready():
	pass


func _physics_process(delta):
	
	if GLOBAL.progress >= 1:
		queue_free()
	
	
