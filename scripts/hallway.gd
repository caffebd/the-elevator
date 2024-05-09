extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.elevator_floor.connect(_elevator_floor)
	Signals.main_floor.connect(_main_floor)
	Signals.hallway_lights_on.connect(_lights_on)
	Signals.hallway_lights_out.connect(_lights_out)

func _elevator_floor():
	%OmniLight3D3.visible = false
	%OmniLight3D4.visible = false

func _main_floor():
	%OmniLight3D3.visible = true
	%OmniLight3D4.visible = true

func _lights_out():
	%OmniLight3D3.visible = false
	%OmniLight3D4.visible = false

func _lights_on():
	%OmniLight3D3.visible = true
	%OmniLight3D4.visible = true
