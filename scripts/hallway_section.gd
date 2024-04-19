extends Node3D

@export var lights_off: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if lights_off:
		%OmniLight3D2.visible=false
		%OmniLight3D6.visible=false
		%OmniLight3D.visible=false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func light_trigger(state):
	print ("light trigger")
	#fade_light(state)
	#%OmniLight3D2.visible=state
	#%OmniLight3D6.visible=state
	#%OmniLight3D.visible=state

func fade_light(state):
	if state:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(%OmniLight3D2, "light_energy", 0.18, 1.0)
		tween.tween_property(%OmniLight3D6, "light_energy", 0.18, 1.0)
		tween.tween_property(%OmniLight3D, "light_energy", 0.05, 1.0)
	else:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(%OmniLight3D2, "light_energy", 0.0, 1.0)
		tween.tween_property(%OmniLight3D6, "light_energy", 0.0, 1.0)
		tween.tween_property(%OmniLight3D, "light_energy", 0.0, 1.0)
		
