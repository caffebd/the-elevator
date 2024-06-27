extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func flash(state):
	if state:
		$AnimationPlayer.play("button_flash")
	else:
		$AnimationPlayer.play("RESET")
