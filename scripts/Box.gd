extends Node3D 



@export var box_number:String=""
@export var locked: bool = false
@export var tool_needed: String

@export var swing_neg: bool = false

@onready var door_panel: StaticBody3D = %DoorPanel

var open: bool = false

var driver_mat = preload("res://assets/UI/driver1_icon.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	%BoxLabel.text = "["+box_number+"]"
	door_panel.my_number = box_number
	door_panel.locked = locked
	door_panel.tool_needed = tool_needed
	if tool_needed != "":
		door_panel.set_tool_image()
	if swing_neg:
		door_panel.swing_dir = -80
	door_panel.setup_box()


