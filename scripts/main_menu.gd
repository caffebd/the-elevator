extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	#SaveState.reset_values()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_day_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://assets/hallwayScene2.tscn")


func _on_stay_home_btn_pressed() -> void:
	get_tree().quit()
