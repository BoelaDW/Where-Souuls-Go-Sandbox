extends Area2D
class_name Ladder



var blockId = 0


func _ready():
	set_physics_process(false)


func _physics_process(delta):
	
	if get_overlapping_bodies() != []:
		for body in get_overlapping_bodies():
			if body is Player:
				if Input.is_action_pressed("ui_up"):
					body.velocity.y = -150
				elif Input.is_action_pressed("ui_down"):
					body.velocity.y = 150
				else:
					body.velocity.y = 10
	
	
	




func addToDB():
	var pos = Vector2(stepify(self.global_position.x,16), stepify(self.global_position.y,16))
	GLOBAL.blockDB.insert(GLOBAL.blockDB.size(),pos)
	blockId = pos
	


func _on_LadderBlock_body_entered(body):
	if body is Player:
		set_physics_process(true)
		body.GRAVITY = 0
		
		


func _on_LadderBlock_body_exited(body):
	if body is Player:
		set_physics_process(false)
		body.GRAVITY = 10
		