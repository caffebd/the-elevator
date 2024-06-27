extends Node3D
#
var monster_floor_attack: bool = false
@export var call_btn: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.elevator_floor.connect(_elevator_floor)
	Signals.main_floor.connect(_main_floor)
	Signals.panel_drop.connect(_monster_appear)
	Signals.call_btn_flash.connect(_call_btn_flash)
	#await get_tree().create_timer(1).timeout
	#Signals.emit_signal("panel_drop", true)
	#await get_tree().create_timer(3.0).timeout
	#Signals.emit_signal("elevator_floor")
	Signals.escape_apartment.connect(_escape)
	#%MainElevator.operate_door(true)
	%SpookSounds.position.y = 0.0
	%ElevatorEnterTrigger.position.z = 2.25
	if SaveState.arm_respawn:
		SaveState.arm_respawn_values()
		Signals.emit_signal("arm_respawn")
		Signals.emit_signal("card_in_slot", false)
		%SpookSounds.position.y = 30.0
		%ElevatorEnterTrigger.position.z = 10.0
	elif SaveState.end_respawn:
		SaveState.end_respawn_values()
		Signals.emit_signal("card_in_slot", true)
		Signals.emit_signal("start_from_black")
		Signals.emit_signal("main_floor")
	
	await get_tree().create_timer(0.5).timeout
	Signals.emit_signal("get_to_work")


func _elevator_floor():
	%MainFloor.visible = false

func _main_floor():
	%MainFloor.visible = true
	%ExitRight.visible = true
	%ChaseTrigger.set_deferred("monitoring", true)
	%SpookSounds.position.y = 30.0
	%ElevatorEnterTrigger.position.z = 10.0

func _escape():
	print ("_escape")
	var tween = create_tween()
	tween.tween_property(%MonsterSting, "volume_db", -50.0, 2.0 )
	await tween.finished
	%MonsterSting.stop()
	%MonsterSting.volume_db = 0.0

func _monster_appear(state):
	if state:
		_call_btn_flash(true)
		monster_floor_attack = true
		%MonsterSting.play()
		await get_tree().create_timer(32.0).timeout
		if monster_floor_attack:
			Signals.emit_signal("monster_grab")
		monster_floor_attack = false
	else:
		_call_btn_flash(false)
		monster_floor_attack = false
		var tween = create_tween()
		tween.tween_property(%MonsterSting, "volume_db", -50.0, 2.0 )
		await tween.finished
		%MonsterSting.stop()
		%MonsterSting.volume_db = 0.0


func _on_reset_body_entered(body):
	if body.is_in_group("Player"):
		body.global_position.x = %ResetPos.global_position.x


func _call_btn_flash(state):
	call_btn.flash(state)



func _on_shake_area_body_exited(body: Node3D) -> void:
	$MainFloor/ElevatorTrigger.set_deferred("monitoring", true)
	#$MainFloor/ShakeArea.set_deferred("monitoring", false)
	#%ChaseMusic.play()



func _on_elevator_trigger_body_entered(body: Node3D) -> void:
	$MainFloor/SpookSounds/PlaySound2.stop()
	$MainFloor/SpookSounds/PlaySound5.stop()
	$MainFloor/SpookSounds/PlaySound3.stop()
	$MainFloor/SpookSounds/PlaySound4.stop()
	#%MainElevator.operate_door(true)
	#$MainFloor/ShakeArea.set_deferred("monitoring", false)
	%elevatorButtonPanel2.buzz_sound_start()
	$MainFloor/ElevatorTrigger.set_deferred("monitoring", false)
	

	


func _on_elevator_enter_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print ("enter")
		%MainElevator.operate_door(false)
		%elevatorButtonPanel2.buzz_sound_start()
		%ElevatorEnterTriggerCollision.set_deferred("disabled", true)
		await get_tree().create_timer(2.0).timeout
		Signals.emit_signal("elevator_sequence_one")


func _on_chase_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		%ChaseTrigger.set_deferred("monitoring", false)
		%MonsterSting.play()
		%MonsterHall.visible = true
		Signals.emit_signal("run_active", true)
		Signals.emit_signal("escape_monster")
		await get_tree().create_timer(1.0).timeout
		_flash_exit()

func _flash_exit():
	for i in 8:
		%ExitLeft.visible = !%ExitLeft.visible
		await get_tree().create_timer(0.15).timeout
	%ExitLeft.visible = true
