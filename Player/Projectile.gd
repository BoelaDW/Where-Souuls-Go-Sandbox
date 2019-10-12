extends KinematicBody2D

var SPEED = 500

var dir = 1

onready var HIT_EFFECT_SCENE = preload("res://Effects/ProjectileHitEffect.tscn")


var velocity = Vector2()


func _ready():
	$DestroyTimer.start()
	$AnimationPlayer.play("Active")

func _physics_process(delta):
	
	velocity.x = SPEED * dir
	
	
	velocity = move_and_slide(velocity)
	


func _on_Area2D_body_entered(body):
	if body is Block or body is Enemy:
		body.destroy()
		var hitEffect = HIT_EFFECT_SCENE.instance()
		get_parent().add_child(hitEffect)
		hitEffect.global_position = self.global_position
		
		
		queue_free()
	

func _on_DestroyTimer_timeout():
	queue_free()


func _on_Area2D_area_entered(area):
	if area is BreakableDoor:
		area.destroy()
		queue_free()
