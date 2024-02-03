extends SpotLight3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.lift_down.connect(_lift_down)
	Signals.lift_up.connect(_lift_up)
	Signals.lift_light_remove.connect(_light_remove)
	Signals.lift_light_gone.connect(_light_gone)
	#Signals.lift_stop.connect(_lift_stop)



func _lift_up():
	if Signals.lift_moving:
		var tween = create_tween()
		tween.tween_property(self, "global_position:y",-0.39, 1.0)
		await tween.finished
		global_position.y = 3.0
		_lift_up()
	else:
		var tween = create_tween()
		tween.tween_property(self, "global_position:y",2.0, 1.0)	
	
func _lift_down():
	if Signals.lift_moving:
		var tween = create_tween()
		tween.tween_property(self, "global_position:y",3.0, 1.0)
		await tween.finished
		global_position.y = -0.39
		_lift_down()
	else:
		var tween = create_tween()
		tween.tween_property(self, "global_position:y",2.0, 1.0)



func _light_remove():
	var tween = create_tween()
	tween.tween_property(self, "global_position:y",-8.0, 2.0)


func _light_gone():
	visible = false
