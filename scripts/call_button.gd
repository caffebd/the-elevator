extends Node3D

@export var call_btn_anim: AnimationPlayer
@export var main_elevator_btn: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.call_btn_flash.connect(_call_btn_flash)


func _call_btn_flash(state):
	if state:
		pass
