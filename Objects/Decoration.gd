extends Node2D

func _ready():
	$Sprite.frame = int(rand_range(9,14))
	