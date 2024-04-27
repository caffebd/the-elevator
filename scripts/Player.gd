extends CharacterBody3D


const WALK_SPEED:float = 1.25


#const SENSITIVITY:float = 0.003
const SENSITIVITY:float = 0.0008

var code_check_pos: int = 0

@export var attack_marker: Marker3D
@export var rotate_marker: Marker3D
@export var lunge_marker: Marker3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 2.0

const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

var constant_wobble:bool = false

#@onready var head = %Head
@onready var camera = %PlayerCam
@onready var ray: RayCast3D = %PlayerRay
@onready var hud = %Hud
@onready var player_hand = %Hand
@onready var head = %Head

var door_opening_a: bool = false

var use_cursor: bool = false

var in_hand:String=""

var driver_1_hand = preload("res://scenes/DriverHand.tscn")
var driver_2_hand = preload("res://scenes/Driver2Hand.tscn")
var fuse_hand = preload("res://scenes/FuseHand.tscn")
var tape_hand = preload("res://scenes/TapeHand.tscn")
var note_hand = preload("res://scenes/NoteHand.tscn")
var crowbar_hand = preload("res://scenes/CrowbarHand.tscn")
var card_hand = preload("res://scenes/CardHand.tscn")

var code_collection:Array[String]=[
	"4835",
	"1378",
	"3333"
]


var call_pos:int = 0

var in_call: bool = false

var note_a_text = "\n         [?] 8 3 5"
var note_b_text = "[u][b][i]You[/i][/b][/u] should [u][b][i]have[/i][/b][/u] taken the stairs [u][b][i]my[/i][/b][/u] [u][b][i]friend[/i][/b][/u]"


@export var test_mode: bool = false

@export var wobble_head:bool = false


#head wobble settings here

#3
#0.05

var BOB_FREQ = 3.0
var BOB_AMP = 0.05
var t_bob = 0.0

var lean_amount = 1.5
var lean_weight = 0.05

#end head wobble settings

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Signals.hand_item.connect(_set_hand_item)
	Signals.remove_item.connect(_remove_item)
	Signals.update_call_step.connect(_update_call_step)
	#camera.current = false
	use_cursor = false
	if test_mode:
		SaveState.code_waiting = 2
		SaveState.wire_fixed = true
		SaveState.fuse_inserted = true
	
	get_saved_inventory()
	initial_box_states()

func _remove_item(item:String):
	_set_hand_item("Hand")
	hud.highlight_hand()
	hud.remove_from_inventory(item)


func _set_hand_item(item:String):
	print ("hand item "+item)
	if player_hand.get_child_count()>0:
		for the_item in player_hand.get_children():
			the_item.queue_free()
		#player_hand.get_child(0).queue_free()
	hud.note_display("")
	match item:
		"Hand":
			in_hand = item
			return
		"Driver1":
			var in_hand_item = driver_1_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
		"Driver2":
			var in_hand_item = driver_2_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
		"Fuse":
			var in_hand_item = fuse_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
		"Tape":
			var in_hand_item = tape_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
		"NoteA":
			var in_hand_item = note_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
			hud.note_display(note_a_text)
		"NoteB":
			var in_hand_item = note_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
			hud.note_display(note_b_text)
		"Crowbar":
			var in_hand_item = crowbar_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
		"Card":
			var in_hand_item = card_hand.instantiate()
			player_hand.add_child(in_hand_item)
			in_hand = item
							
func _input(event):
	if event is InputEventMouseMotion:
		if use_cursor:
			return
		head.rotate_y(-event.relative.x * SENSITIVITY)
		#rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60)) 
	if Input.is_action_just_pressed("ui_cancel"):
		if use_cursor:
			use_cursor = false
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			use_cursor = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_action_just_pressed("use"):
		if not in_call:
			_take_action()
		else:
			start_call()
	
	if Input.is_action_just_released("inventory_up"):
		hud.inventory_up()
	if Input.is_action_just_released("inventory_down"):
		hud.inventory_down()
	
	if Input.is_action_just_pressed("lift_up"):
		Signals.lift_moving = true
		Signals.emit_signal("lift_up")
	if Input.is_action_just_pressed("lift_down"):
		Signals.lift_moving = true
		Signals.emit_signal("lift_down")
	if Input.is_action_just_pressed("lift_stop"):
		Signals.lift_moving = false
		#Signals.emit_signal("lift_stop")
	
	if Input.is_action_just_pressed("to_menu"):
		_to_menu()

	if Input.is_action_just_pressed("test_arm"):
		Signals.emit_signal("door_open","a")
		door_opening_a = true
	
func _take_action():
	var collider = ray.get_collider()
	if collider != null and collider is StaticBody3D:
		if collider.has_method("use_action"):
			collider.use_action(in_hand)
		elif collider.is_in_group("collectible"):
			#hud.SaveState.saved_inventory.append(collider.item_name)
			collider.get_parent().queue_free()
			hud.add_to_inventory(collider.item_name)
		elif collider.is_in_group("number"):
			if not SaveState.wire_fixed and not SaveState.fuse_inserted:
				print ("keypad out of order")
				return
			Signals.emit_signal("key_beep")
			code_entering(collider.name)
			var btn_anim: AnimationPlayer = collider.get_parent().get_child(0)
			btn_anim.play("buttonPress")
			
			#number_highlight(collider.get_child(0))
		elif collider.is_in_group("close"):
			if door_opening_a:
				door_opening_a = false
				#number_highlight(collider.get_child(0))
				var btn_anim: AnimationPlayer = collider.get_parent().get_child(0)
				btn_anim.play("buttonPress")
				_update_call_step(19)
				Signals.emit_signal("eyes_glow", false)
				Signals.emit_signal("door_close")
				Signals.emit_signal("light_up",3)
			else:
				var btn_anim: AnimationPlayer = collider.get_parent().get_child(0)
				btn_anim.play("buttonPress")
		elif collider.is_in_group("open"):
			#number_highlight(collider.get_child(0))
			var btn_anim: AnimationPlayer = collider.get_parent().get_child(0)
			btn_anim.play("buttonPress")
			
			#Signals.emit_signal("roof_eye_sequence", true)
		elif collider.is_in_group("card_slot"):
			if in_hand == "Card" and !SaveState.card_is_in_slot:
				SaveState.card_is_in_slot = true
				_remove_item("Card")
				Signals.emit_signal("card_in_slot", SaveState.card_is_in_slot)
			else:
				if SaveState.card_is_in_slot:
					SaveState.card_is_in_slot = false
					hud.add_to_inventory("Card")
					Signals.emit_signal("card_in_slot", SaveState.card_is_in_slot)
				
		elif collider.is_in_group("call"):
			if not in_call:
				#number_highlight(collider.get_child(0))
				var btn_anim: AnimationPlayer = collider.get_parent().get_child(0)
				btn_anim.play("buttonPress")
				in_call = true
				call_pos = -1
				start_call()

func code_entering(numb:String):
	print ("entered "+str(numb) +"at check pos "+str(code_check_pos))
	print (code_collection.size())
	if SaveState.code_waiting >= code_collection.size():
		return
	if numb == code_collection[SaveState.code_waiting][code_check_pos]:
		code_check_pos += 1
		if code_check_pos == code_collection[SaveState.code_waiting].length():
			print ("CORRECT CODE")
			if SaveState.code_waiting == 0:
				Signals.emit_signal("tray_out",true)
				SaveState.code_waiting = 1
				_update_call_step(12)
			elif SaveState.code_waiting == 1:
				Signals.emit_signal("door_open","a")
				door_opening_a = true
			elif SaveState.code_waiting == 2:
				if SaveState.card_is_in_slot:
					SaveState.code_waiting = 100
					Signals.lift_moving = true
					Signals.emit_signal("lift_up")
					Signals.emit_signal("elevator_move_sound", true)
					var yield_timer_moving = Timer.new()
					add_child(yield_timer_moving)
					yield_timer_moving.start(5);
					await yield_timer_moving.timeout
					Signals.lift_moving = false
					Signals.emit_signal("lift_light_gone")
					yield_timer_moving.queue_free()
					code_check_pos = 0
					Signals.emit_signal("door_open","b")
					_update_call_step(24)
				else:
					Signals.emit_signal("floor_open")
					code_check_pos = 0

			code_check_pos = 0
	elif numb != code_collection[SaveState.code_waiting][code_check_pos-1]:
		code_check_pos = 0

func start_call():
	call_pos += 1
	if call_pos == Call.all_calls[SaveState.call_step].size():
		call_pos = -1
		in_call = false
		hud.update_dialogue("", false)
		if SaveState.call_step == 0:
			Signals.emit_signal("tray_out",true)
			SaveState.call_step = 1
		elif SaveState.call_step == 2:
			SaveState.call_step = 3
		elif SaveState.call_step == 3:
			SaveState.call_step = 4
		elif SaveState.call_step == 5:
			SaveState.call_step = 6
		elif SaveState.call_step == 6:
			SaveState.call_step = 7
		elif SaveState.call_step == 7:
			SaveState.call_step = 8
#call stop
		elif SaveState.call_step == 9:
			SaveState.call_step = 10
		elif SaveState.call_step == 10:
			SaveState.call_step = 11	
#call stop	
		elif SaveState.call_step == 12:
			SaveState.call_step = 13	
#call stop
		elif SaveState.call_step == 14:
			SaveState.call_step = 15
		elif SaveState.call_step == 15:
			SaveState.call_step = 16	
#call stop	
		elif SaveState.call_step == 17:
			SaveState.call_step = 18	
#call stop
		elif SaveState.call_step == 19:
			SaveState.call_step = 20	
		elif SaveState.call_step == 20:
			SaveState.call_step = 21	
#call stop
		elif SaveState.call_step == 22:
			SaveState.call_step = 23	
#call stop
		elif SaveState.call_step == 24:
			SaveState.call_step = 25	
		elif SaveState.call_step == 25:
			SaveState.call_step = 26	
		elif SaveState.call_step == 26:
			SaveState.call_step = 27	
		elif SaveState.call_step == 27:
			SaveState.call_step = 28	
		elif SaveState.call_step == 28:
			SaveState.call_step = 29	
		elif SaveState.call_step == 29:
			SaveState.call_step = 30	
#call stop
	else:
		var sentence = Call.all_calls[SaveState.call_step][call_pos]
		#print (sentence)
		hud.update_dialogue(sentence, call_pos%2==0)
		
func number_highlight(numb):
	numb.modulate = Color(1,0,0,1)
	var yield_timer_key = Timer.new()
	add_child(yield_timer_key)
	yield_timer_key.start(0.2);
	await yield_timer_key.timeout
	numb.modulate = Color(1,1,1,1)
	yield_timer_key.queue_free()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	var space_state = get_world_3d().direct_space_state
	var mousepos = get_viewport().get_mouse_position()

	var origin = camera.project_ray_origin(mousepos)
	var end = origin + camera.project_ray_normal(mousepos) * 2.0
	var query = PhysicsRayQueryParameters3D.create(origin, end)

	var result = space_state.intersect_ray(query)
	
	

	var collider = ray.get_collider()
	hud.target.modulate = Color(1,1,1,0.2)
	Signals.emit_signal("need_fuse", false)
	Signals.emit_signal("fix_wire", false)
	Signals.emit_signal("card_slot_label", false)
	Signals.emit_signal("number_out_of_order", false)
	%PlayerInfoLabel.visible = false
	if collider != null and collider is StaticBody3D:
		if collider.has_method("use_action") or collider.is_in_group("show_hud"):
			hud.target.modulate = Color(1,1,1,1)
		if collider.is_in_group("fuse"):
			Signals.emit_signal("need_fuse", true)
			hud.target.modulate = Color(1,1,1,1)
		if collider.is_in_group("wire"):
			Signals.emit_signal("fix_wire", true)
			hud.target.modulate = Color(1,1,1,1)
		if collider.is_in_group("card_slot"):
			Signals.emit_signal("card_slot_label", true)
			hud.target.modulate = Color(1,1,1,1)
		if collider.is_in_group("roof_panel") and not SaveState.roof_panel_state["tilted"]:
			%PlayerInfoLabel.visible = true
		if collider.is_in_group("number"):
			if not SaveState.fuse_inserted or not SaveState.wire_fixed:
				Signals.emit_signal("number_out_of_order", true)
	
	if collider != null and collider.is_in_group("push_card"):
		hud.target.modulate = Color(1,1,1,1)
		if result and Input.is_action_just_pressed("use"):
			if collider.can_pick_up:
				print ("card pciked")
				hud.add_to_inventory("Card")
				collider.queue_free()
			else:
				collider.apply_central_impulse(-result["normal"])
				Signals.emit_signal("card_click")

		
			
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			#velocity.x = direction.x * speed
			#velocity.z = direction.z * speed
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)


	if wobble_head:
		if input_dir.x>0:
			head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(-lean_amount), lean_weight)
		elif input_dir.x<0:
			head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(lean_amount), lean_weight)
		else:
			head.rotation.z = lerp_angle(head.rotation.z, deg_to_rad(0), lean_weight)
		
		if not constant_wobble:	
			t_bob += delta * velocity.length() * float(is_on_floor())
			camera.transform.origin =_headbob(t_bob)

	if constant_wobble:
		t_bob += delta * 2.0 * float(is_on_floor())
		camera.transform.origin =_headbob(t_bob)

	if abs(velocity.z) + abs(velocity.x) > 1:
		#print ($Footsteps.playing)
		if not $Footsteps.playing:
		#print ("walking")
			$Footsteps.play()
	else:
		#print ("not walking")
		$Footsteps.stop()

	move_and_slide()


func _headbob(time)->Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/ 2) * BOB_AMP
	return pos

func _to_menu():
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")

func _on_fall_area_body_entered(body):
	if body.is_in_group("player"):
		%FallScream.play()
		var fall_timer = Timer.new()
		add_child(fall_timer)
		fall_timer.start(3);
		await fall_timer.timeout
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")


func _update_call_step(step):
	SaveState.call_step = step
	call_pos = -1

func get_saved_inventory():
	if SaveState.saved_inventory.size()==0:
		SaveState.saved_inventory.append("Hand")
		return
		print ("started empty inv")
	var all_collectibles = get_tree().get_nodes_in_group("collectible")
	for item in SaveState.saved_inventory:
		hud.add_to_inventory_from_load(item)
	for node in all_collectibles:
		if SaveState.saved_inventory.has(node.item_name):
			print ("removeig "+node.item_name)
			node.get_parent().queue_free()
	if SaveState.card_is_in_slot == true:
		_remove_item("Card")
		Signals.emit_signal("card_in_slot", SaveState.card_is_in_slot)



			
func initial_box_states():
	if SaveState.box_states.size() > 0:
		return
	var boxes = get_tree().get_nodes_in_group("box")
	for box in boxes:
		SaveState.box_states.append({"number":box.box_number, "locked":box.locked, "open":false}) 
	





func _on_light_area_area_entered(area: Area3D) -> void:
	if area.get_parent().has_method("light_trigger"):
		area.get_parent().light_trigger(true)
		


func _on_light_area_area_exited(area: Area3D) -> void:
	if area.get_parent().has_method("light_trigger"):
		area.get_parent().light_trigger(false)


func _on_shake_area_body_entered(body: Node3D) -> void:
	BOB_FREQ = 150.0
	BOB_AMP = 0.09
	constant_wobble = true


func _on_shake_area_body_exited(body: Node3D) -> void:
	BOB_FREQ = 3.0
	BOB_AMP = 0.05



func _on_elevator_trigger_body_entered(body: Node3D) -> void:
	BOB_FREQ = 3.0
	BOB_AMP = 0.05
	constant_wobble = false
