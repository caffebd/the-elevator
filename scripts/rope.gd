extends Node3D

var click_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.card_click.connect(_card_click)
	

func _card_click():
	click_count += 1
	if click_count == 3:
		$CardPin.queue_free()
		%CardPart.can_pick_up = true
		Signals.emit_signal("top_down_arm")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
