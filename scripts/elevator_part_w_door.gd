extends Node3D

@export var knock_count: int = 1

func _ready() -> void:
	if knock_count == 3:
		get_parent().correct_elevator = true
