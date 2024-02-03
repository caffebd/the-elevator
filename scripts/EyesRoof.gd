extends Node3D


@onready var roof_spot = %RoofLight
@onready var roof_eyes = %RoofEyes
@onready var card = %Card
@onready var arm = %ArmRoof

@export var player: CharacterBody3D
# Called when the node enters the scene tree for the first time.

var sequence_started: bool = false

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	Signals.roof_eye_sequence.connect(_sequence)


func _sequence(state):
	sequence_started = state
	if sequence_started:
		visible = true
		%Card.global_position.y = 2
		roof_eyes_sequence()

func roof_eyes_sequence():
	if sequence_started:
		roof_eyes.visible = false
		roof_spot.visible = true
		if card!= null: 
			card.position.y = - 2.4
		else:
			sequence_started = false
			grab()
			return
		var delay_rnd = rng.randf_range(0.25, 0.75)
		var yield_timer_light = Timer.new()
		add_child(yield_timer_light)
		yield_timer_light.start(delay_rnd);
		await yield_timer_light.timeout
		yield_timer_light.queue_free()
		if card!= null: 
			card.position.y = 2.4
		else:
			sequence_started = false
			grab()
			return
		roof_spot.visible = false
		roof_eyes.visible = true
		var delay_rnd_eyes = rng.randf_range(0.25, 0.75)
		var yield_timer_light_eyes = Timer.new()
		add_child(yield_timer_light_eyes)
		yield_timer_light_eyes.start(delay_rnd);
		await yield_timer_light_eyes.timeout
		yield_timer_light_eyes.queue_free()
		roof_eyes_sequence()
	
	
func grab():
	roof_spot.visible = false
	roof_eyes.visible = true
	arm.global_position.z = player.global_position.z
	arm.global_position.x = player.global_position.x - 1.0
	arm.visible = true
	%ArmRoofAnim.play("arm_drop")
	%ArmGrabRoof.play()
	var arm_timer = Timer.new()
	add_child(arm_timer)
	arm_timer.start(0.4);
	await arm_timer.timeout
	arm_timer.queue_free()
	roof_eyes.visible = false
	arm.visible = false
