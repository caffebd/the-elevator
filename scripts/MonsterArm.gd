extends Node3D

@export var player: CharacterBody3D

var attack_mode: bool = false

const SPEED = 3.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if attack_mode:
		_faceDirection(player.global_position, delta)

func search(state):
	print ("Seacrh now")
	if state:
		$AnimationPlayer.play("Animation")
	else:
		$AnimationPlayer.play_backwards("Animation")

func _grab():
	var direction = global_position.direction_to(player.position)
	#_faceDirection(direction)


func _faceDirection(direction : Vector3, delta: float):
	var target_position = player.attack_marker.global_transform.origin
	print (target_position)
	var new_transform = transform.looking_at(target_position, Vector3.UP)
	
	transform  = transform.interpolate_with(new_transform, SPEED * delta)
