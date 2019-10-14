extends KinematicBody2D
class_name Friendly

var MOVE_SPEED = 40
const JUMP_FORCE = -200
const GRAVITY = 10
const FLOOR = Vector2(0,-1)

var wandering = false
var stopping = false
var notSoFriendly = false

var angerLevel = 0



var onScreen = false
var timerStarted = false



var dir = 1


var velocity = Vector2()




func _ready():
	wandering = true
	$AnimationPlayer.play("Active")
	$AngerTimer.start()



func _physics_process(delta):
	if onScreen:
		
		
		
		#Behaviour changer
		if not timerStarted:
			timerStarted = true
			$WanderTimer.start(rand_range(5,10))
		
		if angerLevel > 10:
			notSoFriendly = true
			wandering = false
			stopping = false
			MOVE_SPEED = 150
			$Eyes.frame = 12
		else:
			$Eyes.frame = 10
			MOVE_SPEED = 40
			notSoFriendly = false
			wandering = true
			stopping = false
		
		
		
		
		
		if velocity.x > 0:
			$Eyes.flip_h = true
			$Body.flip_h = true
		if velocity.x < 0:
			$Eyes.flip_h = false
			$Body.flip_h = false
			
		
		
		if GLOBAL.checkCanMoveLeft(global_position.x) and GLOBAL.checkCanMoveRight(global_position.x):
			pass
		else:
			dir *= -1
		
		velocity.x = MOVE_SPEED * dir
		
		
		if not is_on_floor():
			velocity.y += GRAVITY
		
		
		if wandering:
			
			#Walking up to a wall = can't jump
			if $RCLeft.is_colliding() and $RCJumpableLeft.is_colliding():
				dir = 1
			if $RCRight.is_colliding() and $RCJumpableRight.is_colliding():
				dir = -1
			
			#Walking up to a jumpable ledge
			if $RCLeft.is_colliding() and not $RCJumpableLeft.is_colliding() and is_on_floor():
				velocity.y = JUMP_FORCE
			
			if $RCRight.is_colliding() and not $RCJumpableRight.is_colliding() and is_on_floor():
				velocity.y = JUMP_FORCE
			
		elif notSoFriendly:
			
			if GLOBAL.playerPos.x - 6 > self.global_position.x:
				dir = 1
			
			if GLOBAL.playerPos.x + 6 < self.global_position.x:
				dir = -1
			
			if self.global_position.x < GLOBAL.playerPos.x + 16 and self.global_position.x > GLOBAL.playerPos.x -16:
				if is_on_floor():
					velocity.y = -100
			else:
				if $RCLeft.is_colliding() and $RCJumpableLeft.is_colliding() or $RCRight.is_colliding() and $RCJumpableRight.is_colliding():
					if is_on_floor():
						velocity.y = -300
					
					
					
					
				
				
				
			
		
		
		
		velocity = move_and_slide(velocity,FLOOR)


#Not really destroy, just makes him a bit angry
func destroy():
	
	angerLevel += 1
	

func _on_WanderTimer_timeout():
	timerStarted = false
	
	var behaviour
	
	
	
	


func _on_VisibilityNotifier2D_screen_exited():
	onScreen = false


func _on_VisibilityNotifier2D_screen_entered():
	onScreen = true


func _on_AngerTimer_timeout():
	if angerLevel > 0:
		angerLevel -= 1
	$AngerTimer.start()
