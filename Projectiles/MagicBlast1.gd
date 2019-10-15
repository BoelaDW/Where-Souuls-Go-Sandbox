extends KinematicBody2D

var bodyRotation = 0
var move_speed = 400

var velocity = Vector2()

func _ready():
	$AnimationPlayer.play("Fire")
	velocity.x = move_speed
	$Sprite.rotation = bodyRotation
	velocity = velocity.rotated(bodyRotation)

func _physics_process(delta):
	
	
	
	
	velocity = move_and_slide(velocity)
	
	
	
	



func _on_Area2D_body_entered(body):
	if body is Player or body is Block:
		queue_free()
		
		
