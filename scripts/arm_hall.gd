extends Node3D

@export var player: CharacterBody3D#

var attack_mode: bool = false

var speed = 3.8
const SMOOTH_SPEED = 2.75

var tip_start_pos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%SkeletonIK3D.start()
	#attack_mode = true
	#tip_start_pos = %armTip.global_position
	Signals.escape_monster.connect(_escape)
	Signals.escape_apartment.connect(_escape_apartment)
	visible = false
	#attack_mode = true

func _escape():
	$AnimationPlayer.play("chase")
	attack_mode = true

	
func _arm_fall():
	var tween = create_tween()
	tween.tween_property(self, "global_position:y", 3.0, 0.2)	
	$Sting.play()
	await tween.finished
	var tween_up = create_tween()
	tween_up.tween_property(self, "position:y", 4.0, 0.3)
	
func _arm_drop():
	var tween = create_tween()
	#attack_mode = true
	$Sting.play()
	tween.tween_property(%armTip, "global_position", player.lunge_marker.global_position, 0.3)
	await tween.finished
	var tween_up = create_tween()
	tween_up.tween_property(%armTip, "global_position", tip_start_pos, 0.5)

func _physics_process(delta: float) -> void:
	
	if attack_mode:
		global_position.x -= delta * speed
		#var direction = %ArmHinge.global_transform.origin.direction_to(player.global_transform.origin)
		#var direction_arm = %Armature_005.global_transform.origin.direction_to(player.global_transform.origin)
		##
		###.attack_marker
		#%ArmHinge.rotation.y = lerp_angle(%ArmHinge.rotation.y, atan2(direction.x, direction.z), delta * SMOOTH_SPEED)
		#%Armature_005.rotation.y = %ArmHinge.rotation.y + deg_to_rad(180)


func _on_kill_area_body_entered(body: Node3D) -> void:
	if not attack_mode: return
	if body.is_in_group("Player"):
		Signals.emit_signal("dead_cover")

		#Signals.emit_signal("fade_to_black")
		#await get_tree().create_timer(4.0).timeout
		#Signals.emit_signal("main_floor")

func _escape_apartment():
	speed = -5.0
	await get_tree().create_timer(10.0).timeout
	attack_mode = false
