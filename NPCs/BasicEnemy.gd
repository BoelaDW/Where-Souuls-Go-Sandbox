extends KinematicBody2D
class_name Enemy

const WALK_SPEED = 150
const GRAVITY = 10
const JUMP_FORCE = -200
const FLOOR = Vector2(0,-1)

var dir = 1
var velocity = Vector2()

var hp = 10

var canTurn = true
var shouldFollowPlayer = 0


#For attacking player
var canAttack = true




var isOnScreen = false


func _ready():
	$AnimationPlayer.play("Walk")
	shouldFollowPlayer = randi()%100

func _physics_process(delta):
	
	
	
	
	
	if isOnScreen:
		if shouldFollowPlayer > 80:
			
			if GLOBAL.playerPos.x > self.global_position.x:
				dir = 1
			else:
				dir = -1
		
		if (self.global_position.y - GLOBAL.playerPos.y) > 800:
			destroy()
		
		
		
		if velocity.x > 0:
			$RayCast2D.position.x = 8
			$RayCast2D2.cast_to.x = 16
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
			$RayCast2D.position.x = -8
			$RayCast2D2.cast_to.x = -16
		
		
		velocity.x = WALK_SPEED * dir
		
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity,FLOOR)
		
		if not $RayCast2D.is_colliding() and canTurn:
			dir *= -1
			canTurn = false
			$TurnTimer.start()
		
		if $RayCast2D2.is_colliding():
			dir *= -1
		
		
		
		if hp <= 0:
			if GLOBAL.playerHP < 100:
				GLOBAL.playerHP += 5
			queue_free()
		
		
		
		
		
		

func attackPlayer():
	if canAttack:
		GLOBAL.playerHP -= 5
		canAttack = false
		$AttackTimer.start()
	
	


func destroy():
	hp -= 5
	
	


func _on_TurnTimer_timeout():
	canTurn = true

func _on_VisibilityNotifier2D_screen_exited():
	isOnScreen = false
	dir *= -1


func _on_VisibilityNotifier2D_screen_entered():
	isOnScreen = true


func _on_AttackTimer_timeout():
	canAttack = true
