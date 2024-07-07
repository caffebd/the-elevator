extends Node

var lift_moving: bool = false

signal get_to_work()

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

signal win_game()

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

signal panel_drop(state)
signal top_down_arm()

signal card_click()
signal key_click()

signal player_warp(location)

signal elevator_floor()
signal main_floor()

signal roof_open()
signal roof_close()
signal rope_drop()
signal key_drop()

signal camera_shake()

signal arm_respawn()
signal end_respawn()

signal elevator_sequence_one()
signal elevator_sequence_two()
signal elevator_sequence_three()

signal hallway_lights_out()
signal hallway_lights_on()

signal replace_elevator_floor()

signal player_knock()

signal monster_grab()

signal fade_to_black()
signal start_from_black()

signal fall_main_elevator_respawn()
signal fall_dead_cover()

signal main_elevator_floor_open()

signal call_btn_flash(state)

signal run_active(state)

signal escape_apartment()

signal slam_door()

signal dead_cover()

signal card_freeze(state)

signal escape_monster()

signal fog_state(state)
