extends Area2D

func _ready():
	$AnimationPlayer.play("Active")
	$FlickerTimer.start()
	$HealTimer.start()


func _on_HealTimer_timeout():
	$HealTimer.start()
	if get_overlapping_bodies() != []:
		for body in get_overlapping_bodies():
			if body is Player:
				
				body.heal()
			
			
		
		
	
	
	


func _on_FlickerTimer_timeout():
	pass
	
