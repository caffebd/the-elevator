extends Node

var fuse_inserted: bool = false
var wire_fixed: bool = false

var card_is_in_slot: bool = false

var game_tries: int = 0

var code_waiting: int = 0

var call_step: int = 0

var saved_inventory: Array[String]

var box_states: Array

var phase_done : int = 0

var call_ready: bool = false

var arm_respawn: bool = false

var end_respawn: bool = false

var elec_panel_state:Dictionary = {
	"locked": true,
	"open": false
}

var roof_panel_state: Dictionary = {
	"tilted": false,
	"fallen": false
}

#func save_box(number):

func arm_respawn_values():
	card_is_in_slot = false
	wire_fixed = true
	fuse_inserted = true
	call_ready = true

func end_respawn_values():
	card_is_in_slot = true
	wire_fixed = true
	fuse_inserted = true
	call_ready = true
	
func reset_values():
	elec_panel_state["locked"] = true
	elec_panel_state["open"] = false
	roof_panel_state["tilted"] = false
	roof_panel_state["fallen"] = false
	call_ready = false
	phase_done = 0
	box_states.clear()
	saved_inventory.clear()
	call_step = 0
	code_waiting = 0
	card_is_in_slot = false
	wire_fixed = false
	fuse_inserted = false
	arm_respawn = false
#pahse0
#got screwdriver1

#pahse1
#tape done, wire done
#got screwdriver2
#got noteA
#4835
