extends Node

var fuse_inserted: bool = true
var wire_fixed: bool = true

var card_is_in_slot: bool = false


var code_waiting: int = 0

var call_step: int = 0

var saved_inventory: Array[String]

var box_states: Array

var phase_done : int = 1

var elec_panel_state:Dictionary = {
	"locked": false,
	"open": false
}

var roof_panel_state: Dictionary = {
	"tilted": false,
	"fallen": false
}

#func save_box(number):
	

#pahse0
#got screwdriver1

#pahse1
#tape done, wire done
#got screwdriver2
#got noteA
#4835
