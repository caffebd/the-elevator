extends StaticBody3D

var door_moving: bool = false
@export var final_door: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../../DoorOpen".play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func use_action(tool: String):
	if final_door:
		operate_door()
	else:
		print ("locked")

func operate_door():
	print ("doow click")
	if door_moving:
		return
	door_moving = true
	$"../../DoorOpen".play("open")
	#await get_tree().create_timer(2.0).timeout
	#Signals.emit_signal("win_game")
