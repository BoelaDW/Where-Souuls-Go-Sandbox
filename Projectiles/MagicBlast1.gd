extends KinematicBody2D

var bodyRotation = 0
var move_speed = 400

var velocity = Vector2()



onready var HIT_EFFECT_SCENE = preload("res://Effects/ProjectileHitEffect1.tscn")


func _ready():
	velocity.x = move_speed
	$Sprite.rotation = bodyRotation
	velocity = velocity.rotated(bodyRotation)

func _physics_process(delta):
	
	
	
	
	velocity = move_and_slide(velocity)
	
	
	
	



func _on_Area2D_body_entered(body):
	if body is Player or body is Block:
		
		body.destroy()
		var hitEffect = HIT_EFFECT_SCENE.instance()
		get_parent().add_child(hitEffect)
		hitEffect.global_position = self.global_position
		queue_free()
		
		
