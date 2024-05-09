extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.elevator_floor.connect(_elevator_floor)
	Signals.main_floor.connect(_main_floor)
	#await get_tree().create_timer(1).timeout
	#Signals.emit_signal("panel_drop", true)

func _elevator_floor():
	print ("ele floor vis")
	visible = true

func _main_floor():
	visible = false
