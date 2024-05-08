extends Node3D

var click_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.card_click.connect(_card_click)
	Signals.roof_open.connect(_rope_drop)

func _card_click():
	click_count += 1
	if click_count == 3:
		Signals.emit_signal("top_down_arm")
		$CardPin.queue_free()
		%CardPart.can_pick_up = true
		


func _rope_drop():
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", -0.52, 0.55)
	

