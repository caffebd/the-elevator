extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.door_open.connect(_door_open)
	Signals.door_close.connect(_door_close)


func _door_open(phase):
	if phase == "a":
		Signals.emit_signal("update_call_step",17)
		%DoorAudio.play()
		%DoorAnimation.play("door_open_a")
		Signals.emit_signal("light_down",2)
		var yield_timer_key = Timer.new()
		add_child(yield_timer_key)
		yield_timer_key.start(1.5);
		await yield_timer_key.timeout
		yield_timer_key.queue_free()
		Signals.emit_signal("eyes_glow", true)
	elif phase == "b":
		Signals.emit_signal("elevator_move_sound",false)
		Signals.emit_signal("elevator_door_ding",true)		
		%DoorAnimation.play("door_open_b")
	

func _door_close():
	Signals.emit_signal("update_call_step",19)
	SaveState.code_waiting = 2
	%DoorAudio.play()
	%DoorAnimation.play("door_close")
	Signals.emit_signal("tilt_panel")
	#Signals.emit_signal("show_roof")




func _on_door_animation_animation_finished(anim_name):
	if anim_name == "door_close":
		Signals.emit_signal("hide_elevator_monster")
