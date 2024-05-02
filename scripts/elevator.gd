extends Node3D

var doors_open: bool = false
var doors_moving: bool = false

@onready var right_door: MeshInstance3D = %Cube_029
@onready var left_door: MeshInstance3D = %Cube_002

@onready var main_floor: MeshInstance3D = %Cube_039

var correct_elevator: bool = false

@export var start_elevator_floor: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.panel_drop.connect(_trap_door)
	Signals.floor_open.connect(floor_open)
	left_door.position.z = 0.948
	right_door.position.z = -0.948
	
	if start_elevator_floor:
		await get_tree().create_timer(2).timeout
		operate_door(true)
	
	#await get_tree().create_timer(4).timeout
	#Signals.emit_signal("floor_open")
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


func _trap_door(state):
	if state:
		var tween = create_tween()
		tween.tween_property(%Cube_032, "position:y", -3.0, 0.5)
	else:
		var tween = create_tween()
		tween.tween_property(%Cube_032, "position:y", -1.584, 0.5)

func _on_elevator_trigger_body_entered(body: Node3D) -> void:
	if not doors_open:
		operate_door(true)
		await get_tree().create_timer(4.0).timeout
		operate_door(false)


func floor_open():
	if not correct_elevator:
		var tween = create_tween().set_parallel(true)
		tween.tween_property(main_floor, "position:z", 6.0, 5.0)
		tween.tween_property($Cube_032, "position:z", 6.0, 5.0)
