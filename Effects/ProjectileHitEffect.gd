extends Node2D

func _ready():
	$Timer.start(1)
	$Particles2D.emitting = true


func _on_Timer_timeout():
	queue_free()
