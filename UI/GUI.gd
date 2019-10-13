extends MarginContainer

func _ready():
	pass


func _physics_process(delta):
	
	$GridContainer/VBoxLT/HPBar.value = GLOBAL.playerHP
	$GridContainer/VBoxLT/PowerBar.value = GLOBAL.playerPower
	
	
	
	