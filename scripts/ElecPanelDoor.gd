extends StaticBody3D

var door_open = false

var hinge: MeshInstance3D

var locked: bool = true
var tool_needed: String = "Key"


var swing_dir = 180

# Called when the node enters the scene tree for the first time.
func _ready():
	hinge = get_parent()
	setup_panel()
	



func use_action(tool: String):
	print (locked)
	if locked:
		if not check_locked(tool):
			return
	operate_door()

func operate_door():
	print ("pabeddd")
	door_open = !door_open
	%PanelCol.disabled = true
	if door_open:
		var tween = create_tween()
		print (swing_dir)
		tween.tween_property(hinge, "rotation_degrees:y", swing_dir, 1.0)
		await tween.finished
		%PanelCol.disabled = false
		%FuseBoxSound.play()
	else:
		var tween = create_tween()
		tween.tween_property(hinge, "rotation_degrees:y", 0.0, 1.0)	
		await tween.finished
		%PanelCol.disabled = false
		%FuseBoxSound.play()
	SaveState.elec_panel_state = {"locked": locked, "open": door_open}
	
	
func check_locked(tool:String)->bool:
	if tool == tool_needed:
		locked = false
		return true
	else:
		return false


func setup_panel():
	locked = SaveState.elec_panel_state["locked"]
	door_open = SaveState.elec_panel_state["open"]
	if door_open:
		hinge.rotation_degrees.y = swing_dir
