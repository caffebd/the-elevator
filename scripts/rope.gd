extends Node3D

var click_count: int = 0

var card_frozen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.card_click.connect(_card_click)
	Signals.roof_open.connect(_rope_drop)
	Signals.card_freeze.connect(_card_freeze)

func _card_freeze(state):
	card_frozen = state
	

func _card_click():
	if card_frozen: return
	click_count += 1
	if click_count == 3:
		Signals.emit_signal("top_down_arm")
		$CardPin.queue_free()
		%CardPart.axis_lock_angular_x = true
		%CardPart.axis_lock_angular_y = true
		%CardPart.axis_lock_angular_z = true
		
		await get_tree().create_timer(1).timeout
		%CardPart.linear_velocity = Vector3(0,-5,0)
		%CardPart.can_pick_up = true
		%CardPart.reparent(get_parent())

		


func _rope_drop():
	visible = true
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", -0.52, 0.55)
	
