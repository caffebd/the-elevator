extends StaticBody3D

var door_open = false

var hinge: Node3D

var locked: bool = false
var tool_needed: String

var door_moving: bool = false

var swing_dir = 80

var my_number: String

@onready var box_label = %BoxLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	hinge = get_parent()
	#my_number = get_parent().get_parent().box_number
	
	

func set_tool_image():
	print (name+"   "+tool_needed)
	match tool_needed:
		"Driver1":
			%flathead.visible=true
		"Driver2":
			%phillipsHead.visible=true

func use_action(tool: String):
	print ("locked is "+str(locked))
	if locked:
		if not check_locked(tool):
			return
	operate_door()

func operate_door():
	if door_moving:
		return
	door_moving = true
	_check_call_step()
	door_open = !door_open
	#$DoorCollision.disabled = true
	if door_open:
		var tween = create_tween()
		print (swing_dir)
		tween.tween_property(hinge, "rotation_degrees:y", swing_dir, 1.0)
		await tween.finished
		door_moving = false
		#$DoorCollision.disabled = false
	else:
		var tween = create_tween()
		tween.tween_property(hinge, "rotation_degrees:y", 0.0, 1.0)	
		await tween.finished
		door_moving = false
		#$DoorCollision.disabled = false
	update_box(my_number, locked, door_open)

func check_locked(tool:String)->bool:
	if tool == tool_needed:
		locked = false
		return true
	else:
		return false



func _check_call_step():
	if SaveState.call_step <= 4:
		SaveState.call_step = 5

func update_box(number:String, is_locked: bool, is_open: bool):
	for check in SaveState.box_states:
		if check["number"] == number:
			check["locked"] = is_locked
			check["open"] = is_open

	#print (SaveState.box_states)


func setup_box():
	for check in SaveState.box_states:

		if check["number"] == my_number:
			locked = check["locked"]
			door_open = check["open"]
			if door_open:
				hinge.rotation_degrees.y = swing_dir
