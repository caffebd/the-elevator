extends Node3D

@export var linked_elevator: Node3D

# Called when the node enters the scene tree for the first time.

func open_elevator_door():
	linked_elevator.operate_door(true)
