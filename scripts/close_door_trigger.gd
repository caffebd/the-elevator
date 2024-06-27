extends Area3D

@export var back_inside: CollisionShape3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print ("close doors")
		get_parent().operate_door(false)
		if back_inside:
			back_inside.set_deferred("disabled", false)
		%CloseTriggerCollision.set_deferred("disabled", true)
