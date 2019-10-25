extends KinematicBody2D
class_name Albert

var hp = 500


var hitsUntilStage1 = 5
var bossStage = 0


#This will be incremented by the main loop timer
#And will be responsible for the behaviour of Albert
var bossBehaviourLoop = 0



var stage0CollisionShape = [Vector2(11,42),Vector2(23,46),Vector2(64,80),Vector2(-64,80),Vector2(-32,46)]
var stage1CollisionShape = [Vector2(-5,-80),Vector2(20,-28),Vector2(24,75),Vector2(-24,75),Vector2(-24,-20)]

func _ready():
	var firstStageCollisionShape = ConvexPolygonShape2D.new()
	firstStageCollisionShape.points = stage0CollisionShape
	$CollisionShape2D.shape = firstStageCollisionShape
	$MainLoopTimer.start()








func destroy(dmg = 5):
	
	if hp == 450:
		$AnimationPlayer.play("OpenCoat")
		hp -= dmg
		
	elif hp == 400:
		$AnimationPlayer.play("OpenCoat",-1,-1)
		
		
	elif bossStage > 0 :
		hp -= dmg
		
	else:
		hitsUntilStage1 -= 1
		if hitsUntilStage1 > 0:
			$AnimationPlayer.play("HeapShake")
			
		
		
		if hitsUntilStage1 == 0:
			bossStage += 1
			$AnimationPlayer.play("WakeUp")
			var firstStageCollisionShape = ConvexPolygonShape2D.new()
			firstStageCollisionShape.points = stage1CollisionShape
			$CollisionShape2D.shape = firstStageCollisionShape
		
		
	
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "WakeUp":
		$AnimationPlayer.play("HoverCovered")
	
	elif anim_name == "OpenCoat":
		$AnimationPlayer.play("HoverUncovered")
	

func _on_MainLoopTimer_timeout():
	$MainLoopTimer.start()
	
	if bossBehaviourLoop < 10:
		bossBehaviourLoop += 1
	else:
		bossBehaviourLoop = 0
	print(bossBehaviourLoop)
	
	
	
	
	
	
	if bossStage > 0:
		if GLOBAL.playerPos.x > self.global_position.x + 64:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	
