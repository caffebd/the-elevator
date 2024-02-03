extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.floor_open.connect(_floor_open)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _floor_open():
	%FloorAnim.play("floor_open")
	%FloorOpens.play()
