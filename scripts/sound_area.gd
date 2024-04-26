extends AudioStreamPlayer3D



@export var one_time: bool = false
var played: bool = false



func _on_sound_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if one_time:
			if not played:
				play()
				played = true
		else:
			play()


func _on_sound_trigger_body_exited(body: Node3D) -> void:
	pass # Replace with function body.
