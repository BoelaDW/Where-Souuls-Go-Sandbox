extends KinematicBody2D

var SPEED = 500

var dir = -1
var Ydir = 0


onready var HIT_EFFECT_SCENE = preload("res://Effects/ProjectileHitEffect.tscn")


var velocity = Vector2()


func _ready():
	$DestroyTimer.start()
	$AnimationPlayer.play("Active")
	
	if Ydir == 0:
		
		if dir > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
	else:
		if Ydir == 1:
			$Sprite.rotate(rad2deg(-90))
		elif Ydir == -1:
			$Sprite.rotate(rad2deg(90))
		
		
		

func _physics_process(delta):
	
	
	if Ydir == 0:
		
		velocity.x = SPEED * dir
	else:
		velocity.y = SPEED * Ydir
	
	velocity = move_and_slide(velocity)
	


func _on_Area2D_body_entered(body):
	if body is Block or body is Enemy or body is BuildingDoor or body is Friendly:
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
