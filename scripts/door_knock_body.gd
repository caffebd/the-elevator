extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func use_action(tool: String):
	Signals.emit_signal("player_knock")
	$"../PlayerKnock".play()


func _on_player_knock_finished() -> void:
	await get_tree().create_timer(1.5).timeout
	var knocks = get_parent().knock_count
	
	#match knocks:
		#1:
			#$"../KnockBack1".play()
			#
		#2:
			#$"../KnockBack2".play()
		#3:
			#$"../KnockBack3".play()
		#4:
			#$"../KnockBack4".play()
		#5:
			#$"../KnockBack5".play()
	_show_knock(knocks)


func _show_knock(count):
	for i in count:
		%KnockHand.visible = true
		%KnockAnimation.play("knock")
		$"../KnockBack1".play()
		await %KnockAnimation.animation_finished
		%KnockHand.visible = false
		%KnockHand.global_position = Vector3(0.054, 0.108, -1.076)
		await get_tree().create_timer(0.25).timeout
		
		
	
