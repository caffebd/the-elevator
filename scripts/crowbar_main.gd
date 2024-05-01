extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.set_crowbar.connect(_set_crowbar)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_crowbar():
	if not SaveState.saved_inventory.has("Crowbar"):
		await get_tree().create_timer(2.0).timeout
		visible = true
		global_position.x = -2.4
