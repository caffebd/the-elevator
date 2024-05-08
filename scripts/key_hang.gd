extends Node3D

var click_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.key_click.connect(_key_click)


func _key_click():
	click_count += 1
	if click_count == 3:
		$KeyPin.queue_free()
		%KeyPart.can_pick_up = true
		%KeyGlow.play("glow")
		


