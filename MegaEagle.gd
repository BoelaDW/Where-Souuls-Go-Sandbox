extends KinematicBody2D

const MOVE_SPEED = 50

var dir = 0

var velocity = Vector2()

var points = [Vector2(),Vector2(),Vector2(),Vector2()]
var color = Color(255,0,0)

func _ready():
	$AnimationPlayer.play("Active")


func _draw():
	
	
	draw_colored_polygon (points, color)
	
	
	
	
















func _physics_process(delta):
	
	
	
	if global_position.x <= -500:
		
		#If waiting for the signal to fly over
		if GLOBAL.eagleComing and dir == 0:
			dir = 1
			
		
		#If hitting this point coming from the right
		if GLOBAL.eagleComing and dir == -1:
			GLOBAL.eagleComing = false
			dir = 0
			print("STOPPED ON THE LEFT")
			
		
	elif global_position.x >= GLOBAL.worldGenSize * 16 + 500:
		#If waiting for the signal to fly over
		if GLOBAL.eagleComing and dir == 0:
			dir = -1
			
		
		#If hitting this point coming from the right
		if GLOBAL.eagleComing and dir == 1:
			GLOBAL.eagleComing = false
			dir = 0
			print("STOPPED ON THE RIGHT")
	
	
	
	
	
	
#	points[0] = Vector2($RayCast2D.global_position.x - 2, $RayCast2D.global_position.y)
#	points[1] = Vector2($RayCast2D.global_position.x + 2, $RayCast2D.global_position.y)
#	points[2] = Vector2($ContactPoint.global_position.x - 2, $RayCast2D.global_position.y)
#	points[3] = Vector2($ContactPoint.global_position.x + 2, $RayCast2D.global_position.y)
	
	if velocity.x > 0:
		$RayCast2D.position.x = 36
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false
		$RayCast2D.position.x = -36
	
	
	
	
	if $RayCast2D.is_colliding():
		$ContactPoint.visible = true
		$ContactPoint.global_position = $RayCast2D.get_collision_point()
		
		var collider = $RayCast2D.get_collider()
		if collider.has_method("destroy"):
			collider.destroy(100, false)
			
			
			
			
			
			
			
			
			
			
			
		
		
		
		
		
		#Draw laser beam!!
		var point1 = Vector2(-36, -4)
		var point2 = Vector2(-32, -4)
		var point3 = Vector2(-32, 960)
		var point4 = Vector2(-36, 960)
		
		point1.x = $RayCast2D.position.x - 2
		point2.x = $RayCast2D.position.x + 2
		
		point3.x = $RayCast2D.position.x + 2
		point4.x = $RayCast2D.position.x - 2
		
		point3.y = $ContactPoint.global_position.y - self.global_position.y
		point4.y = $ContactPoint.global_position.y - self.global_position.y
		
		
		points[0] = point1
		points[1] = point2
		points[2] = point3
		points[3] = point4
		
		
		
		
		
		
		update()
		
	else:
		$ContactPoint.visible = false
		
		
		#Draw laser beam!!
		var point1 = Vector2(-36, -4)
		var point2 = Vector2(-32, -4)
		var point3 = Vector2(-32, 960)
		var point4 = Vector2(-36, 960)
		
		point1.x = $RayCast2D.position.x - 2
		point2.x = $RayCast2D.position.x + 2
		
		point3.x = $RayCast2D.position.x + 2
		point4.x = $RayCast2D.position.x - 2
		
		
		
		
		points[0] = point1
		points[1] = point2
		points[2] = point3
		points[3] = point4
		
		update()
	velocity.x = MOVE_SPEED * dir
	
	velocity = move_and_slide(velocity)
	
	
	
	
	
	
	