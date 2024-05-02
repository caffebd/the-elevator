extends Area3D


@export var linked_warp: Marker3D





func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Signals.emit_signal("player_warp", linked_warp.global_position)
