extends Node3D

var broken: bool = true
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.card_in_slot.connect(_card_in_slot)
	Signals.card_slot_label.connect(_card_slot_label)
	$Cylinder.get_surface_override_material(0).emission = Color(1,0,0,1)
	_lights_state()
	
func buzz_sound_start():
	if not $BuzzSound.playing:
		$BuzzSound.play()


func _lights_state():
	#print ("lights wire fuse "+str(SaveState.wire_fixed)+ "  "+str(SaveState.fuse_inserted))
	if SaveState.wire_fixed and SaveState.fuse_inserted:
		%RedLights.visible = false
		%GreenLights.visible = true
		$BuzzSound.stop()
	else:
		%RedLights.visible = true
		%GreenLights.visible = false
		await get_tree().create_timer(rng.randf_range(2.0, 3.0)).timeout
		%RedLights.visible = false
		%GreenLights.visible = true
		await get_tree().create_timer(rng.randf_range(0.4, 0.8)).timeout
		_lights_state()
		
		
func _card_in_slot(state):
	if state:
		%keycard.visible = true
		var tween = create_tween()
		tween.tween_property(%keycard, "position:x", 0.02, 1.0)
		await tween.finished
		$Cylinder.get_surface_override_material(0).emission = Color(0,1,0,1)


func _card_slot_label(state):
	%CardReader.visible = state
