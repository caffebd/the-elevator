extends Node3D

@onready var right_eye = %RightEye
@onready var left_eye = %LeftEye
@onready var arm = %Arm
@export var the_player: CharacterBody3D

var monster_attacking: bool = false

func _ready():
	Signals.eyes_glow.connect(_eyes_glow)
	Signals.hide_elevator_monster.connect(_hide_elevator_monster)
	right_eye.light_energy = 0.0
	left_eye.light_energy = 0.0
	right_eye.spot_angle = 20.0
	left_eye.spot_angle = 20.0

func _hide_elevator_monster():
	visible = false

func _eyes_glow(state):
	monster_attacking = state
	if state:
		_monster_at_door()
	else:
		_monster_retreat()

func _monster_retreat():
	var energy = 0.0
	var angle = 20.0
	var time = 2.0
	%MonsterAudio.stop()
	var arm_tween = create_tween()
	arm_tween.tween_property(arm, "position:z", -1, 1)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(right_eye, "light_energy", energy, time)
	tween.tween_property(left_eye, "light_energy", energy, time)
	tween.tween_property(right_eye, "spot_angle", angle, time)
	tween.tween_property(left_eye, "spot_angle", angle, time)	


func _monster_at_door():
	var energy = 16.0
	var angle = 50.0
	var time = 10.0
	%MonsterAudio.play()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(right_eye, "light_energy", energy, time)
	tween.tween_property(left_eye, "light_energy", energy, time)
	tween.tween_property(right_eye, "spot_angle", angle, time)
	tween.tween_property(left_eye, "spot_angle", angle, time)
	#await tween.finished
	var arm_wait_timer = Timer.new()
	add_child(arm_wait_timer)
	arm_wait_timer.start(5)
	await arm_wait_timer.timeout
	if monster_attacking:
		%ArmEnteringAnim.play("arm_enter")
		var yield_timer_arm = Timer.new()
		add_child(yield_timer_arm)
		yield_timer_arm.start(2.5)
		await yield_timer_arm.timeout
		%MonsterArm.search()
		#%MonsterGrab.play()
		#var arm_tween = create_tween()
		#arm_tween.tween_property(arm, "position:z", 1.5, 1)
		#await arm_tween.finished
		#var yield_timer_arm = Timer.new()
		#add_child(yield_timer_arm)
		#yield_timer_arm.start(1.5);
		#await yield_timer_arm.timeout
		#if monster_attacking:
			#var arm_tween_2 = create_tween()
			#arm_tween_2.tween_property(arm, "global_position", the_player.global_position, 0.2)
			#await arm_tween_2.finished
			#Signals.emit_signal("update_call_step",16)
			#get_tree().change_scene_to_file("res://scenes/Menu.tscn")	
