extends Node2D


onready var PROJECTILE_ONE = preload("res://Projectiles/MagicBlast1.tscn")




func _ready():
	pass


func target(targetPos):
	
	look_at(targetPos)
	
	var RCCollider = $ShootRayCast.get_collider()
	if RCCollider is Player:
		return true
	else:
		return false
	


func fire(projectileType = 0):
	if projectileType == 0:
		
		var projectile = PROJECTILE_ONE.instance()
		projectile.bodyRotation = rotation
		get_parent().add_child(projectile)
		projectile.global_position = $Position2D.global_position
		
		
		
		
		
	
	
	
	