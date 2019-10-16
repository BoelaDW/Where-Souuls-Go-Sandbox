extends Node2D


onready var PROJECTILE_ONE = preload("res://Projectiles/MagicBlast1.tscn")


var canFire = true

func _ready():
	pass


func target(targetPos):
	
	look_at(targetPos)
	
	var RCCollider = $ShootRayCast.get_collider()
	if RCCollider is Player:
		return true
	else:
		return false
	


func fire(projectileType = 0, fireTime = 1):
	if projectileType == 0 and canFire:
		canFire = false
		$FireTimer.start(fireTime)
		
		var projectile = PROJECTILE_ONE.instance()
		projectile.bodyRotation = rotation
		get_parent().get_parent().add_child(projectile)
		projectile.global_position = $Position2D.global_position
		
		
		
		
		
	
	
	
	

func _on_FireTimer_timeout():
	canFire = true
