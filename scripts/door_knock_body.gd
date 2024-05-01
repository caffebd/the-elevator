extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func use_action(tool: String):
	$"../PlayerKnock".play()


func _on_player_knock_finished() -> void:
	await get_tree().create_timer(1.5).timeout
	var knocks = get_parent().knock_count
	match knocks:
		1:
			$"../KnockBack1".play()
		2:
			$"../KnockBack2".play()
		3:
			$"../KnockBack3".play()
		4:
			$"../KnockBack4".play()
		5:
			$"../KnockBack5".play()
