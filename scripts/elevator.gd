extends Node3D

var doors_open: bool = false
var doors_moving: bool = false

@onready var left_door: MeshInstance3D = %Cube_029
@onready var right_door: MeshInstance3D = %Cube_002

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	left_door.position.z = 0.948
	right_door.position.z = -0.948
	
	pass
	#await get_tree().create_timer(4).timeout
	#operate_door(true)



func operate_door(state):
	doors_open = state
	if doors_open:
		$Ding.play()
		await get_tree().create_timer(0.25).timeout
		var tween = create_tween().set_parallel(true)
		tween.tween_property(left_door, "position:z", 1.9, 2.7)
		tween.tween_property(right_door, "position:z", -1.9, 2.7)
		await tween.finished
		doors_moving = false
	else:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(left_door, "position:z", 0.948, 2.0)
		tween.tween_property(right_door, "position:z", -0.948, 2.0)
		await tween.finished
		doors_moving = false	


func _on_elevator_trigger_body_entered(body: Node3D) -> void:
	if not doors_open:
		operate_door(true)
