extends Node2D

func _ready():
	$Timer.start(1)
	$LightOffTimer.start()
	$Particles2D.emitting = true


func _on_Timer_timeout():
	queue_free()


func _on_LightOffTimer_timeout():
	$Light2D.enabled = false
