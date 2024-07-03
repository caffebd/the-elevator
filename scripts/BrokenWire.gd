extends StaticBody3D

@onready var wire_label = %BrokenWire
@onready var taped_wire = %yellowTape

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.fix_wire.connect(_wire_label)
	if SaveState.wire_fixed:
		wire_taped()
		#the_tape.queue_free()

func _wire_label(state):
	if not taped_wire.visible:
		wire_label.visible = state


func use_action(tool: String):
	if tool == "Tape":
		print ("place tape")
		Signals.emit_signal("remove_item","Tape")
		wire_taped()

func wire_taped():
	taped_wire.visible = true
	SaveState.wire_fixed = true
	wire_label.visible = false
