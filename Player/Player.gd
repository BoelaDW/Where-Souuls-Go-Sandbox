extends KinematicBody2D
class_name Player


const INTERPOLATE_SPEED = 10
const WALK_SPEED = 200
const GRAVITY = 10
const JUMP_FORCE = -300
const FLOOR = Vector2(0,-1)

var velocity = Vector2()
var dir = 1

var lPressed = false
var rPressed = false

#Coyote Time
var canJump

var canFire = true

onready var PROJECTILE = preload("res://Player/Projectile.tscn")

func _ready():
	pass


func getInput():
	
	if Input.is_action_pressed("ui_right"):
		rPressed = true
	else:
		rPressed = false
	
	if Input.is_action_pressed("ui_left"):
		lPressed = true
	else:
		lPressed = false
	
	if Input.is_action_pressed("ui_select") and is_on_floor():
		
		velocity.y = JUMP_FORCE
	
	if Input.is_action_pressed("ui_accept") and canFire:
		var projectile = PROJECTILE.instance()
		projectile.dir = dir
		projectile.velocity.x += velocity.x
		get_parent().add_child(projectile)
		projectile.global_position = $FirePosition.global_position
		canFire = false
		$CanFireTimer.start()
		
		shakeCamera()
	
	

func _physics_process(delta):
	
	getInput()
	
	
	
	if global_position.y > 2000:
		GLOBAL.goto_scene("res://WorldGenerateMenu.tscn")
	GLOBAL.playerPos = self.global_position
	
	
	if rPressed and not lPressed:
		$FirePosition.position.x = 10
		velocity = velocity.linear_interpolate(Vector2(WALK_SPEED,velocity.y), delta * INTERPOLATE_SPEED)
		$Body.flip_h = true
		$Eyes.flip_h = true
		dir = 1
	elif lPressed and not rPressed:
		$FirePosition.position.x = -10
		velocity = velocity.linear_interpolate(Vector2(-WALK_SPEED,velocity.y), delta * INTERPOLATE_SPEED)
		$Body.flip_h = false
		$Eyes.flip_h = false
		dir = -1
	else:
		velocity = velocity.linear_interpolate(Vector2(0,velocity.y), delta * INTERPOLATE_SPEED)
	
	
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity,FLOOR)
	

func _on_CanFireTimer_timeout():
	canFire = true



var shakeProgress = 0
func shakeCamera():
	
	$ShakeTimer.start()
	shakeProgress += 1
	



func _on_ShakeTimer_timeout():
	if shakeProgress < 5 and shakeProgress > 0:
		$Camera2D.offset = Vector2(randi()%3 * dir,rand_range(-3,3))
		shakeCamera()
	else:
		shakeProgress = 0
		$Camera2D.offset = Vector2()
