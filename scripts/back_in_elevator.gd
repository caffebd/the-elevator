extends Area3D

@export var outside_trigger: CollisionShape3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		%BackInsideCollision.set_deferred("disabled", true)
		if outside_trigger:
			outside_trigger.set_deferred("disabled", false)
		await get_tree().create_timer(2.0).timeout
		get_parent().operate_door(false)
		await get_tree().create_timer(3.0).timeout
		get_parent().floor_open()
		
