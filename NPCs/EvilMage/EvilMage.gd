extends KinematicBody2D
class_name EvilMage

var MOVE_SPEED = 50
const GRAVITY = 10
const FLOOR = Vector2(0,-1)
const JUMP_FORCE = -200

var velocity = Vector2()
var dir = 1
var dirSave = 0


var hp = 100

var guard = false
var healer = false
var attackMage = false

#This position is set when Mage is on guard
#It is used as a marker point to stay close to when patrolling


func _ready():
	MOVE_SPEED = int(rand_range(20,40))



func _physics_process(delta):
	
	if velocity.x < 0:
		$Sprite.flip_h = true
	elif velocity.x > 0:
		$Sprite.flip_h = false
	
	
	
	if guard:
		
		
		if (GLOBAL.playerPos.x < self.global_position.x + 500 and GLOBAL.playerPos.x > self.global_position.x - 500) or (GLOBAL.angryPos.x < self.global_position.x + 500 and GLOBAL.angryPos.x > self.global_position.x - 500):
			
			#If it targets something with the "destroy" method
			if $TargetSystem.target(GLOBAL.playerPos):
				$TargetSystem.fire()
				
				if GLOBAL.playerPos.x > self.global_position.x:
					$Sprite.flip_h = false
				else:
					$Sprite.flip_h = true
				
				
				if dirSave == 0:
					dirSave = dir
				dir = 0
			else:
				if dirSave != 0:
					dir = dirSave
					dirSave = 0
				
			
		if $FloorCheckRCLeft.is_colliding() and not $FloorCheckRCRight.is_colliding():
			dir = -1
		if $FloorCheckRCRight.is_colliding() and not $FloorCheckRCLeft.is_colliding():
			dir = 1
		
		
		if $WallCheckRCLeft.is_colliding() and not $WallCheckRCRight.is_colliding():
			dir = 1
		if $WallCheckRCRight.is_colliding() and not $WallCheckRCLeft.is_colliding():
			dir = -1
		
		
		if $WallCheckRCLeft.is_colliding() and $WallCheckRCRight.is_colliding():
			dir = 0
			print("CAN'T MOVE...")
		
	
	
	if hp >= 100:
		$HealthBar.visible = false
	else:
		$HealthBar.visible = true
	$HealthBar/ProgressBar.value = hp
	
	velocity.y += GRAVITY
	velocity.x = MOVE_SPEED * dir
	velocity = move_and_slide(velocity,FLOOR)
	
	
	


func destroy(dmg = 10):
	hp -= dmg
	if hp <= 0:
		
		queue_free()
	
	
	
	
	
