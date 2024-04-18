extends Node3D

@export var lights_off: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if lights_off:
		$OmniLight3D2.visible=false
		$OmniLight3D6.visible=false
		$OmniLight3D.visible=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
