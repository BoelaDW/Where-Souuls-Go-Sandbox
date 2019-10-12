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

func _ready():
	$AnimationPlayer.play("Walk")
	shouldFollowPlayer = randi()%100
	GLOBAL.enemiesInLevel += 1

func _physics_process(delta):
	
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
		


func destroy():
	GLOBAL.enemiesInLevel -= 1
	GLOBAL.enemiesKilled += 1
	print(GLOBAL.enemiesInLevel)
	queue_free()
	
	


func _on_TurnTimer_timeout():
	canTurn = true