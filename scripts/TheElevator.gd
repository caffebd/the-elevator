extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Signals.elevator_move_sound.connect(_elevator_move_sound)
	Signals.elevator_door_ding.connect(_elevator_door_ding)


func _elevator_door_ding(state):
	if state:
		%ElevatorDingDoor.play()
	else:
		%ElevatorDingDoor.stop()

func _elevator_move_sound(state):
	if state:
		%ElevatorMove.play()
	else:
		%ElevatorMove.stop()
