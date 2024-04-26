extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_reset_body_entered(body):
	if body.is_in_group("Player"):
		body.global_position.x = %ResetPos.global_position.x






func _on_shake_area_body_exited(body: Node3D) -> void:
	$ElevatorTrigger.monitoring = true
	%ChaseMusic.play()



func _on_elevator_trigger_body_entered(body: Node3D) -> void:
	$SpookSounds/PlaySound2.stop()
	$SpookSounds/PlaySound5.stop()
	$SpookSounds/PlaySound3.stop()
	$SpookSounds/PlaySound4.stop()
