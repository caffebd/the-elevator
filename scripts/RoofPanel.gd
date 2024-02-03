extends StaticBody3D

var tilted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.tilt_panel.connect(_tilt_panel)
	setup_state()

func use_action(tool: String):
	if tool == "Crowbar" and SaveState.roof_panel_state["tilted"]==true:
		%RookPanelAdim.play("fall")
		rotation_degrees.z = 0
		Signals.emit_signal("roof_eye_sequence", true)
		SaveState.roof_panel_state["fallen"]=true


func _tilt_panel():
	tilted = true
	SaveState.roof_panel_state["tilted"]=true
	%RookPanelAdim.play("tilt")

func setup_state():
	if SaveState.roof_panel_state["fallen"]:
		global_position.y = 0.038
		if SaveState.saved_inventory.has("Card") or SaveState.card_is_in_slot:
			return
		Signals.emit_signal("roof_eye_sequence", true)
	elif SaveState.roof_panel_state["tilted"]:
		%RookPanelAdim.play("tilt")
