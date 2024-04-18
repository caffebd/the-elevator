extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	do_loop()


func do_loop():
	%AnimationPlayer.play("searching")
	var yield_timer_moving = Timer.new()
	add_child(yield_timer_moving)
	yield_timer_moving.start(8);
	await yield_timer_moving.timeout
	print ("ATTACK")
	%AnimationPlayer.play_backwards("searching")
	var yield_timer_moving_b = Timer.new()
	add_child(yield_timer_moving_b)
	yield_timer_moving_b.start(8);
	await yield_timer_moving_b.timeout
	%AnimationPlayer.play_backwards("attack")
	var yield_timer_moving_c = Timer.new()
	add_child(yield_timer_moving_c)
	yield_timer_moving_c.start(8);
	await yield_timer_moving_c.timeout
	do_loop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
