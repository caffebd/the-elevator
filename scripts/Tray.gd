extends Node3D

var crowbar_collected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.tray_out.connect(_tray_move)
	Signals.set_crowbar.connect(_set_crowbar)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _tray_move(state):
	if state:
		$TrayAnim.play("tray_out")
	else:
		$TrayAnim.play("tray_in")



func _on_tray_anim_animation_finished(anim_name):
	pass
	#if anim_name == "tray_in" and not crowbar_collected:
		#%Crowbar.visible = true
		#%Crowbar.position.y = 0.794
		#crowbar_collected = true


func _set_crowbar():
	if not SaveState.saved_inventory.has("Crowbar"):
		var yield_timer_moving = Timer.new()
		add_child(yield_timer_moving)
		yield_timer_moving.start(2);
		await yield_timer_moving.timeout
		%Crowbar.visible = true
		%Crowbar.position.y = 0.794
		crowbar_collected = true
		yield_timer_moving.queue_free()
