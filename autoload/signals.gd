extends Node

var lift_moving: bool = false


signal hand_item(item)
signal tray_out(state)

signal lift_up()
signal lift_down()
signal lift_stop()

signal need_fuse(state)
signal fix_wire(state)
signal card_slot_label(state)

signal remove_item(item)

signal door_open(phase)
signal door_close()

signal floor_open()

signal light_down(speed)
signal light_up(speed)

signal eyes_glow(state)

signal lift_light_remove()
signal lift_light_gone()

signal roof_eye_sequence(state)

signal card_in_slot(state)

signal update_call_step(step)

signal show_roof()

signal hide_elevator_monster()

signal elevator_move_sound(state)
signal elevator_door_ding(state)

signal key_beep()
signal number_out_of_order(state)

signal tilt_panel()

signal set_crowbar()
