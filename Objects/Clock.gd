extends Node2D

func _ready():
	pass


func _physics_process(delta):
	
	$Hand.rotation_degrees = stepify(GLOBAL.currentGameTime * 360,0.5)*4
	
	
	