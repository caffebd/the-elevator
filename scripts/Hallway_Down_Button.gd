extends Node3D

@export var linked_elevator: Node3D
@export var main_floor_button: bool = false

var disabled: bool = false

# Called when the node enters the scene tree for the first time.

func open_elevator_door():
	if disabled: return
	if main_floor_button and SaveState.game_tries == 0:
		linked_elevator.door_broken()
	else:
		linked_elevator.operate_door(true)
