extends Node

#----------------------------------------------
#GLOBAL VARIABLES GO HERE
var worldGenSeed = 0
var worldGenSize = 100
var klaraModeEnabled = false


var playerPos = Vector2()

var playerHP = 100
var playerPower = 100
var playerCanMove = 1


var selectedToolbarTool = 0



var blockID = 0
onready var blockDB = []


var angryPos = Vector2()





#----------------------------------------------


func checkCanMoveRight(globalXPosition):
	
	if globalXPosition < worldGenSize*16 - 24:
		return true
	else:
		return false

func checkCanMoveLeft(globalXPosition):
	if globalXPosition > 24:
		return true
	else:
		return false
	
	


var loader
var wait_frames
var time_max = 100 # msec
var current_scene


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)



func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		print("ERROR")
		#show_error()
		return
	set_process(true)
	current_scene.queue_free() # get rid of the old scene
	# start your "loading..." animation
	#get_node("animation").play("loading")
	
	wait_frames = 1



func _process(time):
	if loader == null:
		# no need to process anymore
		set_process(false)
		return
	
	if wait_frames > 0: # wait for frames to let the "loading" animation show up
		wait_frames -= 1
		return
	
	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control for how long we block this thread
		
		# poll your loader
		var err = loader.poll()
		
		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			print("SOME OTHER ERROR")
			loader = null
			break




func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	# Update your progress bar?
	#get_node("progress").set_progress(progress)
	print(progress)
	# ... or update a progress animation?
	#var length = get_node("animation").get_current_animation_length()
	
	# Call this on a paused animation. Use "true" as the second argument to force the animation to update.
	#get_node("animation").seek(progress * length, true)
	

func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)






#func goto_scene(path):
#    # This function will usually be called from a signal callback,
#    # or some other function in the current scene.
#    # Deleting the current scene at this point is
#    # a bad idea, because it may still be executing code.
#    # This will result in a crash or unexpected behavior.
#
#    # The solution is to defer the load to a later time, when
#    # we can be sure that no code from the current scene is running:
#	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)








