extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Signals.emit_signal("fall_dead_cover")
		Signals.emit_signal("replace_elevator_floor")
		await get_tree().create_timer(1.0).timeout
		SaveState.game_tries += 1
		Signals.emit_signal("fall_main_elevator_respawn")
		Signals.emit_signal("card_freeze", false)
		
