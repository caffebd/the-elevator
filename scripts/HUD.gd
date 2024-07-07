extends Control

@onready var target: TextureRect = %target

var target_mode = "off"

var driver1_icon = preload("res://scenes/Driver1Icon.tscn")
var driver2_icon = preload("res://scenes/Driver2Icon.tscn")
var fuse_icon = preload("res://scenes/FuseIcon.tscn")
var tape_icon = preload("res://scenes/TapeIcon.tscn")
var note_icon_a = preload("res://scenes/NoteIconA.tscn")
var note_icon_b = preload("res://scenes/NoteIconB.tscn")
var crowbar_icon = preload("res://scenes/CrowbarIcon.tscn")
var card_icon = preload("res://scenes/CardIcon.tscn")
var key_icon = preload("res://scenes/KeyIcon.tscn")

var inventory_index: int = 0

var knocking: bool = false

@onready var inventory_grid = %Inventory

#var SaveState.saved_inventory:Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_inventory_color(0)
	Signals.player_knock.connect(_player_knock)
	Signals.fade_to_black.connect(_fade_to_black)
	Signals.dead_cover.connect(_dead_cover)
	Signals.win_game.connect(_win_screen)
	Signals.start_from_black.connect(_start_from_black)
	Signals.fall_dead_cover.connect(_fall_dead_cover)
	#%Dialogue.add_theme_color_override("font_color", Color("ffff00"))

func _dead_cover():
	$DeadCover.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _fall_dead_cover():
	%FallDeadCover.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func knock_icon(state):
	if not knocking:
		%KnockIcon.visible = state

func _player_knock():
	var wait_time: float = 0.15
	knocking = true
	%KnockIcon.visible = true
	%KnockIcon2.visible = false
	await get_tree().create_timer(wait_time).timeout
	%KnockIcon.visible = false
	%KnockIcon2.visible = true	
	await get_tree().create_timer(wait_time).timeout
	
	%KnockIcon.visible = true
	%KnockIcon2.visible = false
	await get_tree().create_timer(wait_time).timeout
	%KnockIcon.visible = false
	%KnockIcon2.visible = true	
	await get_tree().create_timer(wait_time).timeout
	knocking = false
	%KnockIcon.visible = false
	%KnockIcon2.visible = false	
	
	
	
func remove_from_inventory(item:String):
	if SaveState.saved_inventory.has(item):
		for child in inventory_grid.get_children():
			if child.name == item+"Icon":
				child.queue_free()
				SaveState.saved_inventory.remove_at(SaveState.saved_inventory.find(item,0))
		print (SaveState.saved_inventory)

func add_to_inventory(item:String):
	if not SaveState.saved_inventory.has(item):
		match item:
			"Driver1":
				var icon_scene = driver1_icon.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)
				Signals.emit_signal("tray_out", false)
				Signals.emit_signal("set_crowbar")
				Signals.emit_signal("update_call_step",3)
			"Driver2":
				var icon_scene = driver2_icon.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)
			"Fuse":
				var icon_scene = fuse_icon.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)
			"Tape":
				var icon_scene = tape_icon.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)
			"NoteA":
				var icon_scene = note_icon_a.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)
				Signals.emit_signal("update_call_step",9)
			"NoteB":
				var icon_scene = note_icon_b.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)	
				Signals.emit_signal("update_call_step",14)
			"Crowbar":
				var icon_scene = crowbar_icon.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)
				Signals.emit_signal("tray_out", false)
			"Card":
				var icon_scene = card_icon.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)
				Signals.emit_signal("update_call_step",22)
				#Signals.emit_signal("tray_out", false)
			"Key":
				var icon_scene = key_icon.instantiate()
				inventory_grid.add_child(icon_scene)
				SaveState.saved_inventory.append(item)

func add_to_inventory_from_load(item: String):
	match item:
		"Driver1":
			var icon_scene = driver1_icon.instantiate()
			inventory_grid.add_child(icon_scene)
			Signals.emit_signal("set_crowbar")
		"Driver2":
			var icon_scene = driver2_icon.instantiate()
			inventory_grid.add_child(icon_scene)
		"Fuse":
			var icon_scene = fuse_icon.instantiate()
			inventory_grid.add_child(icon_scene)
		"Tape":
			var icon_scene = tape_icon.instantiate()
			inventory_grid.add_child(icon_scene)
		"NoteA":
			var icon_scene = note_icon_a.instantiate()
			inventory_grid.add_child(icon_scene)
		"NoteB":
			var icon_scene = note_icon_b.instantiate()
			inventory_grid.add_child(icon_scene)
		"Crowbar":
			var icon_scene = crowbar_icon.instantiate()
			inventory_grid.add_child(icon_scene)
		"Card":
			var icon_scene = card_icon.instantiate()
			inventory_grid.add_child(icon_scene)
		"Key":
			var icon_scene = key_icon.instantiate()
			inventory_grid.add_child(icon_scene)


func set_target_mode(mode:String):
	if mode == target_mode:
		return
	target_mode = mode
	if target_mode=="off":
		target.modulate.a = 145.0
	elif target_mode == "interact":
		target.modulate.a = 255.0


func inventory_up():
	var size = inventory_grid.get_child_count()
	print ("size "+str(size))
	inventory_index += 1
	if inventory_index == size:
		inventory_index = 0
	
	print (SaveState.saved_inventory[inventory_index])
	_set_inventory_color(inventory_index)
	Signals.emit_signal("hand_item", SaveState.saved_inventory[inventory_index])
	print (SaveState.saved_inventory)		

func inventory_down():
	var size = inventory_grid.get_child_count()
	inventory_index -= 1	
	if inventory_index<0:
		inventory_index = size-1
	print (SaveState.saved_inventory[inventory_index])
	_set_inventory_color(inventory_index)
	Signals.emit_signal("hand_item", SaveState.saved_inventory[inventory_index])	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_1"):
		var size = inventory_grid.get_child_count()
		if 0 > size-1:
			print ("nothing in inventory")
		else:
			inventory_index = 0
			_inventory_keyboard_update()
		
	if event.is_action_pressed("inventory_2"):
		var size = inventory_grid.get_child_count()
		if 1 > size-1:
			print ("nothing in inventory")
		else:
			inventory_index = 1
			_inventory_keyboard_update()
		
	if event.is_action_pressed("inventory_3"):
		var size = inventory_grid.get_child_count()
		if 2 > size-1:
			print ("nothing in inventory")
		else:
			inventory_index = 2
			_inventory_keyboard_update()

	if event.is_action_pressed("inventory_4"):
		var size = inventory_grid.get_child_count()
		if 3 > size-1:
			print ("nothing in inventory")
		else:
			inventory_index = 3
			_inventory_keyboard_update()

	if event.is_action_pressed("inventory_5"):
		var size = inventory_grid.get_child_count()
		if 4 > size-1:
			print ("nothing in inventory")
		else:
			inventory_index = 4
			_inventory_keyboard_update()

	if event.is_action_pressed("inventory_6"):
		var size = inventory_grid.get_child_count()
		if 5 > size-1:
			print ("nothing in inventory")
		else:
			inventory_index = 5
			_inventory_keyboard_update()

	if event.is_action_pressed("inventory_7"):
		var size = inventory_grid.get_child_count()
		if 6> size-1:
			print ("nothing in inventory")
		else:
			inventory_index = 6
			_inventory_keyboard_update()

	if event.is_action_pressed("inventory_8"):
		var size = inventory_grid.get_child_count()
		if 7 > size-1:
			print ("nothing in inventory")
		else:
			inventory_index = 7
			_inventory_keyboard_update()

func _inventory_keyboard_update():
	print ("HUD INPUT")
	_set_inventory_color(inventory_index)
	Signals.emit_signal("hand_item", SaveState.saved_inventory[inventory_index])	

func highlight_hand():
	inventory_index = 0
	_set_inventory_color(inventory_index)

func _set_inventory_color(index:int):
	for i in inventory_grid.get_children():
		i.color = Color(1,1,1,0.15)
	inventory_grid.get_child(index).color = Color(1,1,1,1)


func note_display(note:String):
	print ("show note "+note)
	if note=="":
		%Notes.visible = false
		%NoteTexture.visible = false
		%NoteText.visible = false
		%LockerPuzzle.visible = false
		return
	if note=="locker":
		%Notes.visible = true
		%LockerPuzzle.visible = true
		return
	%Notes.visible = true
	%NoteText.text = note
	%NoteTexture.visible = true
	%NoteText.visible = true
	%LockerPuzzle.visible = false

func update_dialogue(sentence:String, player_speak:bool):
	if sentence != "":
		%Dialogue.text = sentence
		%Dialogue.visible = true
		if player_speak:
			%PlayerAvatar.visible = true
			%Dialogue.add_theme_color_override("font_color", Color("ffffff"))
			%CallAvatar.visible = false
		else:
			%CallAvatar.visible = true
			%Dialogue.add_theme_color_override("font_color", Color("ffff00"))
			%PlayerAvatar.visible = false
	else:
		%Dialogue.visible = false
		%PlayerAvatar.visible = false
		%CallAvatar.visible = false


func _fade_to_black():
	var tween = create_tween()
	tween.tween_property(%BlackCover, "modulate:a", 1.0, 3.0)
	await get_tree().create_timer(4.0).timeout
	_fade_to_clear()

func _start_from_black():
	%BlackCover.modulate.a = 1
	await get_tree().create_timer(1.0).timeout
	_fade_to_clear()

func _fade_to_clear():
	var tween = create_tween()
	tween.tween_property(%BlackCover, "modulate:a", 0.0, 2.0)
	print ("faded cear")

func _process(delta: float) -> void:
	var fps = Engine.get_frames_per_second() 
	$fps.text = str(fps)

func _win_screen():
	SaveState.reset_values()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	%WinCover.visible = true
	if SaveState.game_tries == 0:
		%LateCount.text = "You were not even late!"
	elif SaveState.game_tries == 1:
		%LateCount.text = "...but you were 1 day late."
	else:
		%LateCount.text = "...but you were "+str(SaveState.game_tries)+ " days late."
		


func _on_next_day_btn_pressed() -> void:
	SaveState.game_tries += 1
	if SaveState.arm_respawn:
		get_tree().change_scene_to_file("res://assets/hallwayScene2.tscn")
	elif SaveState.end_respawn:
		get_tree().change_scene_to_file("res://assets/hallwayScene2.tscn")
	else:
		SaveState.reset_values()
		get_tree().change_scene_to_file("res://assets/hallwayScene2.tscn")


func _on_quit_job_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_menu_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_fall_next_day_btn_pressed() -> void:
	%FallDeadCover.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	await get_tree().create_timer(0.5).timeout
	Signals.emit_signal("get_to_work")
