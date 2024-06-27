extends Node3D

var doors_open: bool = false
var doors_moving: bool = false

@onready var right_door: MeshInstance3D = %Cube_029
@onready var left_door: MeshInstance3D = %Cube_002

@onready var main_floor: MeshInstance3D = %Cube_039

var correct_elevator: bool = false

@export var start_elevator_floor: bool = false
@export var elevator_floor: bool = false

var left_closed: float = 0.948
var right_closed: float = -0.948

var main_floor_start: float
var main_floor_cube_start: float


var door_changing: Array[float] = [0.15, 0.0, 0.2, 0.0, 0.1, 0.0, 0.2, 0.0, 0.3, 0.0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.panel_drop.connect(_trap_door)
	Signals.floor_open.connect(floor_open)
	Signals.roof_open.connect(_roof_open)
	Signals.roof_close.connect(_roof_close)
	Signals.elevator_floor.connect(_elevator_floor)
	Signals.main_elevator_floor_open.connect(_main_elevator_floor_open)
	Signals.main_floor.connect(_main_floor)
	Signals.replace_elevator_floor.connect(_replace_elevator_floor)
	Signals.elevator_sequence_one.connect(_elevator_sequence_one)
	Signals.elevator_sequence_two.connect(_elevator_sequence_two)
	Signals.elevator_sequence_three.connect(_elevator_sequence_three)
	left_door.position.z = 0.948
	right_door.position.z = -0.948
	main_floor_start = main_floor.position.z
	main_floor_cube_start = %Cube_032.position.z

func _replace_elevator_floor():
	print ("replace floor")
	%Cube_032.position.z = main_floor_cube_start
	main_floor.position.z = main_floor_start
	

func _elevator_floor():
	if start_elevator_floor:
		await get_tree().create_timer(2).timeout
		operate_door(true)

func _main_floor():
	if not elevator_floor:
		operate_door(true)
	#await get_tree().create_timer(3).timeout
	#_door_slow_open()
	#Signals.emit_signal("hallway_lights_out")
	#_door_banging()
	#_elevator_sequence_two()
	#Signals.emit_signal("roof_open")
	#operate_door(true)



func operate_door(state):
	print ("operate door")
	
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
		$Ding.play()
		var tween = create_tween().set_parallel(true)
		tween.tween_property(left_door, "position:z", 0.948, 2.0)
		tween.tween_property(right_door, "position:z", -0.948, 2.0)
		await tween.finished
		doors_moving = false	
	$Ding.volume_db = -10.0

func door_broken():
	$Ding.play()
	var tween = create_tween().set_parallel(true)
	tween.tween_property(left_door, "position:z", 1.1, 4.0)
	tween.tween_property(right_door, "position:z", -1.1, 4.0)
	await tween.finished
	var tween_slam = create_tween().set_parallel(true)
	tween_slam.tween_property(left_door, "position:z", 0.948, 0.25)
	tween_slam.tween_property(right_door, "position:z", -0.948, 0.25)
	%Slam.play()

func _trap_door(state):
	if state:
		%Cube_032.visible = false
		
		#var tween = create_tween()
		#tween.tween_property(%Cube_032, "position:y", -3.0, 0.5)
	else:
		%Cube_032.visible = true
		#var tween = create_tween()
		#tween.tween_property(%Cube_032, "position:y", -1.533, 0.5)

func _on_elevator_trigger_body_entered(body: Node3D) -> void:
	if not doors_open:
		operate_door(true)
		#await get_tree().create_timer(4.0).timeout
		#operate_door(false)


func floor_open():
	if not correct_elevator:
		%FloorMoving.play()
		var tween = create_tween().set_parallel(true)
		tween.tween_property(main_floor, "position:z", 6.0, 9.0)
		tween.tween_property($Cube_032, "position:z", 6.0, 9.0)
	else:
		%ElevatorMoving.play()
		_up_arrow(true)
		await get_tree().create_timer(5).timeout
		Signals.emit_signal("fade_to_black")
		await get_tree().create_timer(3).timeout
		SaveState.end_respawn = true
		Signals.emit_signal("main_floor")	

func _main_elevator_floor_open():
		%FloorMoving.play()
		var tween = create_tween().set_parallel(true)
		tween.tween_property(main_floor, "position:z", 6.0, 9.0)
		tween.tween_property($Cube_032, "position:z", 6.0, 9.0)	

func _roof_open():
	var tween = create_tween()
	tween.tween_property(%Cube_034, "rotation:z", deg_to_rad(90.0), 1.0)

func _roof_close():
	var tween = create_tween()
	tween.tween_property(%Cube_034, "rotation:z", deg_to_rad(0.0), 1.0)
	
func _elevator_sequence_one():
	if not elevator_floor:
		%ElevatorMoving.play()
		_down_arrow(true)
		await get_tree().create_timer(8).timeout
		_down_arrow(false)
		%ElevatorMoving.stop()
		%ElevatorCrash.play()
		_roof_open()
		Signals.emit_signal("key_drop")
		Signals.emit_signal("camera_shake", 3.0, 0.07)
		_arrow_flash()
		_poster_flash()
		Signals.emit_signal("call_btn_flash", true)

func _poster_flash():
	for i in 20:
		%ProblemPoster.visible = !%ProblemPoster.visible
		await get_tree().create_timer(0.1).timeout
	%ProblemPoster.visible = true

func _elevator_sequence_two():
	if not elevator_floor:
		SaveState.call_ready = false
		%ElevatorMoving.play()
		_up_arrow(true)
		await get_tree().create_timer(5).timeout
		Signals.emit_signal("camera_shake", 8.0, 0.03)
		_arrow_flash()
	
	await get_tree().create_timer(2).timeout
	_door_slow_open()
	#Signals.emit_signal("panel_drop", true)

func _elevator_sequence_three():
	if not elevator_floor:
		%ElevatorMoving.play()
		_up_arrow(true)
		await get_tree().create_timer(5).timeout
		Signals.emit_signal("fade_to_black")
		await get_tree().create_timer(3).timeout
		Signals.emit_signal("elevator_floor")
		#get_tree().change_scene_to_file("res://scenes/ElevatorFloor.tscn")

func _door_slow_open():
	if not elevator_floor:
		Signals.emit_signal("hallway_lights_out")
		_arrow_flash()
		var tween = create_tween().set_parallel(true)
		tween.tween_property(left_door, "position:z", left_closed + 0.2, 6.0)
		tween.tween_property(right_door, "position:z", right_closed - 0.2, 6.0)
		await tween.finished
		var tween_close = create_tween().set_parallel(true)
		tween_close.tween_property(left_door, "position:z", left_closed, 0.2)
		tween_close.tween_property(right_door, "position:z", right_closed, 0.2)	

func _door_banging():
	if not elevator_floor:
		Signals.emit_signal("hallway_lights_out")
		_arrow_flash()
		for i in 10:
			print (i)
			$Ding.play()
			#await get_tree().create_timer(0.25).timeout
			var tween = create_tween().set_parallel(true)
			tween.tween_property(left_door, "position:z", left_closed + door_changing[i], 0.5)
			tween.tween_property(right_door, "position:z", right_closed - door_changing[i], 0.5)
			await tween.finished

	
	
func _arrow_flash():
	if not elevator_floor:
		var show_state = true
		for i in 20:
			_down_arrow(show_state)
			_up_arrow(!show_state)
			await get_tree().create_timer(0.05).timeout
			show_state = !show_state
		_down_arrow(false)
		_up_arrow(false)
		SaveState.call_ready = true
	
func _down_arrow(state):
	%Cube_038.get_surface_override_material(0).emission_enabled = state
	

func _up_arrow(state):
	%Cube_037.get_surface_override_material(0).emission_enabled = state
