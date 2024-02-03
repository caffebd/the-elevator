extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.light_down.connect(fade_down)
	Signals.light_up.connect(fade_up)
	Signals.roof_eye_sequence.connect(_roof_eye)
	Signals.show_roof.connect(_show_roof)


func _roof_eye(state):
	%RoffUpSpot.visible = !state

func _show_roof():
	%RoffUpSpot.visible = true

func fade_down(speed:float):
	Signals.emit_signal("lift_light_remove")
	for light in get_children():
		print (light.name)
		var tween = create_tween()
		tween.tween_property(light, "light_energy", 0.1, speed )

func fade_up(speed:float):
	for light in get_children():
		var tween = create_tween()
		tween.tween_property(light, "light_energy", 1.5, speed )
