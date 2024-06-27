extends Node3D

@onready var card_in_slot = %CardInSlot
@onready var card_slot_label = %CardReader

func _ready():
	Signals.card_in_slot.connect(_insert_card)
	Signals.card_slot_label.connect(_card_slot_label)
	Signals.number_out_of_order.connect(_number_out_of_order)
	Signals.key_beep.connect(_key_beep)


func _insert_card(state):
	card_in_slot.visible = state


func _card_slot_label(state):
	card_slot_label.visible = state

func _key_beep():
	%KeyBeep.play()

func _number_out_of_order(state):
	%NumberOutofOrder.visible = state
