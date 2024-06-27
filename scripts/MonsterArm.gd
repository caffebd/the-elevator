extends Node3D

@export var player: CharacterBody3D

var attack_mode: bool = false

const SPEED = 3.0
const SMOOTH_SPEED = 2.75

var grabbing: bool = false

var follow: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.panel_drop.connect(_trap_door)
	Signals.monster_grab.connect(_grab)
	Signals.arm_respawn.connect(_arm_respawn)
	%SkeletonIK3D.start()
	global_position.y = -30.0
	#$AnimationPlayer.play_backwards("searching")
	#var arm_grab_timer = Timer.new()
	#add_child(arm_grab_timer)
	#arm_grab_timer.start(5.0);
	#await arm_grab_timer.timeout
	#$AnimationPlayer.play_backwards("searching")
	###rotation.y = lerp(rotation.y, -90.0, 0.001)
	#var arm_grab_timer_b = Timer.new()
	#add_child(arm_grab_timer_b)
	#arm_grab_timer_b.start(5.0);
	#await arm_grab_timer_b.timeout
	#attack_mode = true
	#var arm_grab_timer_b = Timer.new()
	#add_child(arm_grab_timer_b)
	#arm_grab_timer_b.start(5.0);
	#await arm_grab_timer_b.timeout
	#$AnimationPlayer.play("attack")
	attack_mode = false
	follow = false

func _arm_respawn():
	attack_mode = false
	global_position.y = -20.0
	grabbing = false


func _trap_door(state):
	if state:
		var tween = create_tween()
		tween.tween_property(self, "global_position:y", 0.0, 3)
		#await tween.finished
		await get_tree().create_timer(2.8).timeout
		attack_mode = true
		follow = true
	else:
		attack_mode = false
		follow = false
		var tween = create_tween()
		tween.tween_property(self, "global_position:y", 30.0, 0.5)
		

func _physics_process(delta: float) -> void:
	if attack_mode:
		var direction = %ArmHinge.global_transform.origin.direction_to(player.rotate_marker.global_transform.origin)
		var direction_arm = %Armature_005.global_transform.origin.direction_to(player.rotate_marker.global_transform.origin)
		#
		##.attack_marker
		%ArmHinge.rotation.y = lerp_angle(%ArmHinge.rotation.y, atan2(direction.x, direction.z), delta * SMOOTH_SPEED)
		%Armature_005.rotation.y = %ArmHinge.rotation.y + deg_to_rad(180)
		#+ deg_to_rad(180)
		#lerp_angle(%Armature_005.rotation.y+0.09, atan2(direction.x, direction.z), delta * SMOOTH_SPEED)

		if not grabbing and follow:
			%ArmHinge.global_position = lerp(%ArmHinge.global_position, player.attack_marker.global_position, delta * SMOOTH_SPEED)
			
			%ArmHinge.global_position.x = clamp(%ArmHinge.global_position.x, -6.5, -4.0)
			%ArmHinge.global_position.y = clamp(%ArmHinge.global_position.y, 1.0,1.7)
			%ArmHinge.global_position.z = clamp(%ArmHinge.global_position.z, 1.8,3.0)
			#print (%ArmHinge.global_position)
			
		#rotation.y = lerp_angle(rotation.y+0.092, atan2(direction.x, direction.z), delta * SMOOTH_SPEED)
		#%armTip.rotation.y += 0.2
		#print (compensate)


		#var lookPos = player.global_transform.origin
		#lookPos.y = global_transform.origin.y 
		#%armTip.look_at(lookPos,Vector3(0,1,0))	

		#var offset = player.global_transform.origin - global_transform.origin
		#var dir = Vector2(offset.x,offset.z)
		#var NPCAngle = get_rotation().y
		#var angleBetween = -rad_to_deg(dir.angle_to(Vector2(-sin(NPCAngle),-cos(NPCAngle))))
		#while (abs(angleBetween) > 10):
			#angleBetween -= 5
			#print (angleBetween)
			#rotate_y(angleBetween)
		#_faceDirection(Vector3(global_position.x,global_position.y, player.global_position.z ), delta)

func search(state):
	print ("Seacrh now")
	if state:
		$AnimationPlayer.play("searching")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play_backwards("searching")
		await $AnimationPlayer.animation_finished
		attack_mode = true
		var arm_grab_timer = Timer.new()
		add_child(arm_grab_timer)
		arm_grab_timer.start(7.0);
		await arm_grab_timer.timeout
		$AnimationPlayer.play("attack")	
		global_position = lerp(global_position,Vector3(player.global_position.x, 3.0, player.global_position.z), 0.4)

func _grab():
	grabbing = true
	player.player_freeze = true
	await get_tree().create_timer(0.25).timeout
	var grab_to:Vector3 =  player.lunge_marker.global_position
	#%armTip.global_position = lerp(%armTip.global_position,Vector3(grab_to.x, grab_to.y, grab_to.z), 0.30)
	var tween = create_tween()
	tween.tween_property(%ArmHinge, "global_position", Vector3(grab_to.x, grab_to.y, grab_to.z), 0.15)
	await get_tree().create_timer(0.25).timeout
	Signals.emit_signal("dead_cover")
	player.player_freeze = false
	
	#$AnimationPlayer.play("attack")
	#var direction = global_position.direction_to(Vector3(player.position.x,global_position.y, global_position.z ))
	#_faceDirection(direction)


func _faceDirection(direction : Vector3, delta: float):
	var target_position = player.attack_marker.global_transform.origin
	print (target_position)
	var new_transform = transform.looking_at(target_position, Vector3.UP)
	
	transform  = transform.interpolate_with(new_transform, SPEED * delta)
	


func _on_follow_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		follow = true
		print (follow)




func _on_follow_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		follow = false
		print (follow)
