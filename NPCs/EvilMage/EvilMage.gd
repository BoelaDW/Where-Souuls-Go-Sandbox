extends KinematicBody2D
class_name EvilMage

var MOVE_SPEED = 50
const GRAVITY = 10
const FLOOR = Vector2(0,-1)
const JUMP_FORCE = -200

var velocity = Vector2()
var dir = 1

var hp = 100

var guard = false
var healer = false
var attackMage = false




func _ready():
	pass



func _physics_process(delta):
	
	if guard:
		
		dir = 0
		if GLOBAL.playerPos.x < self.global_position.x + 200 and GLOBAL.playerPos.x > self.global_position.x - 200:
			
			#If it targets something with the "destroy" method
			if $TargetSystem.target(GLOBAL.playerPos):
				$TargetSystem.fire()
				
				
			
		
		
		
	
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity,FLOOR)
	
	
	

