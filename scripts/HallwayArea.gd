extends Node3D
#
var monster_floor_attack: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.elevator_floor.connect(_elevator_floor)
	Signals.main_floor.connect(_main_floor)
	Signals.panel_drop.connect(_monster_appear)
	#await get_tree().create_timer(1).timeout
	#Signals.emit_signal("panel_drop", true)
	#await get_tree().create_timer(3.0).timeout
	#Signals.emit_signal("main_floor")
	Signals.escape_monster.connect(_escape)

func _elevator_floor():
	%MainFloor.visible = false

func _main_floor():
	%MainFloor.visible = true
	%ChaseTrigger.set_deferred("monitoring", true)

func _escape():
	var tween = create_tween()
	tween.tween_property(%MonsterSting, "volume_db", -50.0, 2.0 )
	await tween.finished
	%MonsterSting.stop()
	%MonsterSting.volume_db = 0.0

func _monster_appear(state):
	if state:
		monster_floor_attack = true
		%MonsterSting.play()
		await get_tree().create_timer(32.0).timeout
		if monster_floor_attack:
			Signals.emit_signal("monster_grab")
		monster_floor_attack = false
	else:
		monster_floor_attack = false
		var tween = create_tween()
		tween.tween_property(%MonsterSting, "volume_db", -50.0, 2.0 )
		await tween.finished
		%MonsterSting.stop()
		%MonsterSting.volume_db = 0.0


func _on_reset_body_entered(body):
	if body.is_in_group("Player"):
		body.global_position.x = %ResetPos.global_position.x






func _on_shake_area_body_exited(body: Node3D) -> void:
	$MainFloor/ElevatorTrigger.set_deferred("monitoring", true)
	$MainFloor/ShakeArea.set_deferred("monitoring", false)
	#%ChaseMusic.play()



func _on_elevator_trigger_body_entered(body: Node3D) -> void:
	$MainFloor/SpookSounds/PlaySound2.stop()
	$MainFloor/SpookSounds/PlaySound5.stop()
	$MainFloor/SpookSounds/PlaySound3.stop()
	$MainFloor/SpookSounds/PlaySound4.stop()
	%MainElevator.operate_door(true)
	$MainFloor/ElevatorTrigger.set_deferred("monitoring", false)
	

	


func _on_elevator_enter_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print ("enter")
		%MainElevator.operate_door(false)
		%ElevatorEnterTriggerCollision.set_deferred("disabled", true)
		await get_tree().create_timer(2.0).timeout
		Signals.emit_signal("elevator_sequence_one")


func _on_chase_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		%ChaseTrigger.set_deferred("monitoring", false)
		%MonsterSting.play()
		%MonsterHall.visible = true
		%MonsterHall.attack_mode = true
