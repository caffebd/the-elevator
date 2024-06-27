extends StaticBody3D

var door_open = false

var hinge: MeshInstance3D

var locked: bool = false
@export var crowbar: Node3D

var crowbar_collected: bool = false

var swing_dir = 180.0

# Called when the node enters the scene tree for the first time.
func _ready():
	hinge = get_parent()
	#setup_panel()
	Signals.tray_out.connect(_tray_move)
	

func _tray_move(state):
	print ("tray to move")
	door_open = !door_open
	%PanelCol.disabled = true
	if door_open:
		var tween = create_tween()
		print (swing_dir)
		tween.tween_property(hinge, "rotation_degrees:y", swing_dir, 0.7)
		%SecretDoorOpenSound.play()
		await tween.finished
		%PanelCol.disabled = false
		
	else:
		var tween = create_tween()
		tween.tween_property(hinge, "rotation_degrees:y", 0.0, 1.0)	
		await tween.finished
		%PanelCol.disabled = false
