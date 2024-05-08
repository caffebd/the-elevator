extends Node3D

var pulse_values: Array[float] = [0.3, 1.2, 0.7, 1.3, 0.8, 1.8, 0.6, 1.2, 0.4, 0.0]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.hallway_lights_on.connect(_lights_on)
	Signals.hallway_lights_out.connect(_lights_out)


func _lights_on():
	%light_007.visible = true
	%OmniLight3D3.visible = true
	%OmniLight3D4.visible = true

func _lights_out():
	%light_007.visible = false
	%OmniLight3D3.visible = false
	%OmniLight3D4.visible = false
	_red_pulse()

func _red_pulse():
	$RedLight.visible = true
	for i in 10:
		var tween = create_tween()
		tween.tween_property($RedLight, "light_energy", pulse_values[i], 0.6)
		await  tween.finished
	$RedLight.visible = false
	Signals.emit_signal("hallway_lights_on")
	Signals.emit_signal("panel_drop", true)
