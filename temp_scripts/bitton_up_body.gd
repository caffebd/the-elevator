extends StaticBody3D

var activated: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func use_action(tool: String):
	activated = !activated
	Signals.emit_signal("panel_drop", activated)
