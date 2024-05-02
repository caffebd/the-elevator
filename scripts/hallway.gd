extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.elevator_floor.connect(_elevator_floor)

func _elevator_floor():
	%OmniLight3D3.visible = false
	%OmniLight3D4.visible = false
	
