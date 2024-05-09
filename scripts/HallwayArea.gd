extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.elevator_floor.connect(_elevator_floor)
	Signals.main_floor.connect(_main_floor)
	#await get_tree().create_timer(1).timeout
	#Signals.emit_signal("panel_drop", true)

func _elevator_floor():
	%MainFloor.visible = false

func _main_floor():
	%MainFloor.visible = true




func _on_reset_body_entered(body):
	if body.is_in_group("Player"):
		body.global_position.x = %ResetPos.global_position.x






func _on_shake_area_body_exited(body: Node3D) -> void:
	$ElevatorTrigger.monitoring = true
	$ShakeArea.set_deferred("monitoring", false)
	#%ChaseMusic.play()



func _on_elevator_trigger_body_entered(body: Node3D) -> void:
	$SpookSounds/PlaySound2.stop()
	$SpookSounds/PlaySound5.stop()
	$SpookSounds/PlaySound3.stop()
	$SpookSounds/PlaySound4.stop()

	


func _on_elevator_enter_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print ("enter")
		%MainElevator.operate_door(false)
		%ElevatorEnterTriggerCollision.set_deferred("disabled", true)
		await get_tree().create_timer(2.0).timeout
		Signals.emit_signal("elevator_sequence_one")
