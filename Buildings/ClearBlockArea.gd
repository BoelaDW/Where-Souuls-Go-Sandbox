extends Area2D


func _ready():
	
	pass



#This will set the size of the area that will remove unwanted blocks
func setSize(houseSize):
	
	var colShape = $CollisionShape2D
	
	var shape = ConvexPolygonShape2D.new() #Creates a new convex polygon shape
	
	var regArray = [Vector2(-64, -16), Vector2(houseSize.x + 64, -16), Vector2(houseSize.x + 300, houseSize.y * -2), Vector2(-256, houseSize.y * -2)] #Creates a regular array filled with Vector2s`
	
	var poolarray = PoolVector2Array(regArray) #Converts the regular array into a PoolVector2Array. This is needed to apply the new points to the shape since ConvexPolygonShape2D.set_points method requires a PoolVector2Array.
	
	shape.set_points(poolarray)
	
	colShape.set_shape(shape)
	
	#$CollisionShape2D.set_extents(houseSize)
	
	#clearUnwantedBlocks()
	
	


func _physics_process(delta):
	
	
	#This will run right until the scene is loaded, it detects blocks, and then removes them
	if get_overlapping_bodies() != []:
		
		clearUnwantedBlocks()
	

func clearUnwantedBlocks():
	
	
	for body in self.get_overlapping_bodies():
		
		
		if body is Block and body.canBeCleared:
			body.destroy()
		
	queue_free()


