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
			
			
		
		
	if $CheckGroundRC.is_colliding() == false and $VisibilityNotifier2D.is_on_screen():
		queue_free()
		
	
	


func _on_FlickerTimer_timeout():
	pass
	


func _on_VisibilityNotifier2D_screen_entered():
	pass # Replace with function body.
