extends StaticBody3D

var door_open: bool = false

var door_moving: bool = false

@export var hinge: Node3D

var swing_dir = 180.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func use_action(tool: String):
	operate_door()

func operate_door():
	print ("doow click")
	if door_moving:
		return
	door_moving = true
	
	print (door_open)
	door_open = !door_open
	#$DoorCollision.disabled = true
	if door_open:
		
		var tween = create_tween()
		tween.tween_property(hinge, "rotation_degrees:y", swing_dir, 1.0)
		await tween.finished
		door_moving = false
	else:
		var tween = create_tween()
		tween.tween_property(hinge, "rotation_degrees:y", 90.0, 1.0)	
		await tween.finished
		door_moving = false
