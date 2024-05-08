extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.card_in_slot.connect(_card_in_slot)
	Signals.card_slot_label.connect(_card_slot_label)
	Signals.key_beep.connect(_key_beep)
	


func _card_in_slot(state):
	if state:
		%keycard.visible = true
		var tween = create_tween()
		tween.tween_property(%keycard, "position:x", 0.02, 1.0)
		await tween.finished
		$Cylinder.get_surface_override_material(0).emission = Color(0,1,0,1)


func _card_slot_label(state):
	%CardReader.visible = state

func _key_beep():
	%KeyBeep.play()

