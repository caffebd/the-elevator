extends StaticBody3D

var door_open: bool = false

var door_moving: bool = false

@export var hinge: Node3D

var swing_dir = 180.0

var door_active:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.slam_door.connect(_slam_door)


func use_action(tool: String):
	operate_door()

func _slam_door():
	door_active = false
	door_open = false
	var tween = create_tween()
	tween.tween_property(hinge, "rotation_degrees:y", 90.0, 0.3)	
	await tween.finished
	door_moving = false	

func operate_door():
	print ("doow click")
	if door_moving:
		return
	if not door_active:
		return
	door_moving = true
	
	print (door_open)
	door_open = !door_open
	#$DoorCollision.disabled = true
	if door_open:
		Signals.emit_signal("escape_apartment")
		var tween = create_tween()
		tween.tween_property(hinge, "rotation_degrees:y", swing_dir, 1.0)
		await tween.finished
		door_moving = false
	else:
		var tween = create_tween()
		tween.tween_property(hinge, "rotation_degrees:y", 90.0, 1.0)	
		await tween.finished
		door_moving = false
