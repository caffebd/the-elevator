extends Node3D

var click_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.key_click.connect(_key_click)
	Signals.key_drop.connect(_key_drop)
	

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr


	

func _key_click():
	click_count += 1
	if click_count == 3:
		$KeyPin.queue_free()
		%KeyPart.can_pick_up = true
		%KeyPart.axis_lock_angular_x = true
		%KeyPart.axis_lock_angular_y = true
		%KeyPart.axis_lock_angular_z = true
		%KeyGlow.play("glow")
		%KeyPart.reparent(get_parent())
		await get_tree().create_timer(2.0).timeout
		_key_rise()
		Signals.emit_signal("roof_close")
		


func _key_drop():
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", -0.255, 0.55)

func _key_rise():
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", 2.255, 0.55)


		#var node_to_reparent = get_parent()
		#var new_parent = $node/path/here/again
		#for child in get_all_children(node_to_reparent):
			#child.reparent(new_parent)
			#child.owner=get_tree().edited_scene_root
