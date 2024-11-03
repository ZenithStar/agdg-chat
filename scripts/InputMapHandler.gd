extends Node

func _ready():
	var joy_left_left = InputEventJoypadMotion.new()
	joy_left_left.axis = 0
	joy_left_left.axis_value = -1.0
	var key_a: InputEventKey = InputEventKey.new()
	key_a.keycode = KEY_A
	InputMap.add_action("move_left")
	InputMap.action_add_event("move_left", joy_left_left)
	InputMap.action_add_event("move_left", key_a)
	
	var joy_left_right = InputEventJoypadMotion.new()
	joy_left_right.axis = 0
	joy_left_right.axis_value = 1.0
	var key_d: InputEventKey = InputEventKey.new()
	key_d.keycode = KEY_D
	InputMap.add_action("move_right")
	InputMap.action_add_event("move_right", joy_left_right)
	InputMap.action_add_event("move_right", key_d)
	
	var joy_left_up = InputEventJoypadMotion.new()
	joy_left_up.axis = 1
	joy_left_up.axis_value = -1.0
	var key_w: InputEventKey = InputEventKey.new()
	key_w.keycode = KEY_W
	InputMap.add_action("move_forward")
	InputMap.action_add_event("move_forward", joy_left_up)
	InputMap.action_add_event("move_forward", key_w)
	
	var joy_left_down = InputEventJoypadMotion.new()
	joy_left_down.axis = 1
	joy_left_down.axis_value = 1.0
	var key_s: InputEventKey = InputEventKey.new()
	key_s.keycode = KEY_S
	InputMap.add_action("move_back")
	InputMap.action_add_event("move_back", joy_left_down)
	InputMap.action_add_event("move_back", key_s)
	
	var joypad_south = InputEventJoypadButton.new()
	joypad_south.button_index = 0
	var key_space: InputEventKey = InputEventKey.new()
	key_space.keycode = KEY_SPACE
	InputMap.add_action("jump")
	InputMap.action_add_event("jump", joypad_south)
	InputMap.action_add_event("jump", key_space)
	
	var joypad_north = InputEventJoypadButton.new()
	joypad_north.button_index = 3
	var key_c: InputEventKey = InputEventKey.new()
	key_c.keycode = KEY_C
	InputMap.add_action("crouch")
	InputMap.action_add_event("crouch", joypad_north)
	InputMap.action_add_event("crouch", key_c)
	
	var joy_right_left = InputEventJoypadMotion.new()
	joy_right_left.axis = 2
	joy_right_left.axis_value = -1.0
	InputMap.add_action("camera_left")
	InputMap.action_add_event("camera_left", joy_right_left)
	
	var joy_right_right = InputEventJoypadMotion.new()
	joy_right_right.axis = 2
	joy_right_right.axis_value = 1.0
	InputMap.add_action("camera_right")
	InputMap.action_add_event("camera_right", joy_right_right)
	
	var joy_right_up = InputEventJoypadMotion.new()
	joy_right_up.axis = 3
	joy_right_up.axis_value = -1.0
	InputMap.add_action("camera_up")
	InputMap.action_add_event("camera_up", joy_right_up)
	
	var joy_right_down = InputEventJoypadMotion.new()
	joy_right_down.axis = 3
	joy_right_down.axis_value = 1.0
	InputMap.add_action("camera_down")
	InputMap.action_add_event("camera_down", joy_right_down)
	
	var joypad_west = InputEventJoypadButton.new()
	joypad_west.button_index = 2
	var key_e: InputEventKey = InputEventKey.new()
	key_e.keycode = KEY_E
	InputMap.add_action("interact")
	InputMap.action_add_event("interact", joypad_west)
	InputMap.action_add_event("interact", key_e)
	
	var joypad_east = InputEventJoypadMotion.new()
	joypad_east.axis = 5
	joypad_east.axis_value = 1.0
	var key_shift: InputEventKey = InputEventKey.new()
	key_shift.keycode = KEY_SHIFT
	InputMap.add_action("sprint")
	InputMap.action_add_event("sprint", joypad_east)
	InputMap.action_add_event("sprint", key_shift)
	
	var joypad_r3 = InputEventJoypadButton.new()
	joypad_r3.button_index = 8
	var key_tab: InputEventKey = InputEventKey.new()
	key_tab.keycode = KEY_TAB
	InputMap.add_action("target")
	InputMap.action_add_event("target", joypad_r3)
	InputMap.action_add_event("target", key_tab)
	
	var joypad_start = InputEventJoypadButton.new()
	joypad_start.button_index = 6
	var key_escape: InputEventKey = InputEventKey.new()
	key_escape.keycode = KEY_ESCAPE
	InputMap.add_action("pause")
	InputMap.action_add_event("pause", joypad_start)
	InputMap.action_add_event("pause", key_escape)
	
	# do controller players even deserve to zoom?
	InputMap.add_action("zoom_in")
	InputMap.add_action("zoom_out")

	for i in 10:
		var number: InputEventKey = InputEventKey.new()
		number.keycode = (KEY_0 + i) as Key
		InputMap.add_action("hotbar_%s"%[i])
		InputMap.action_add_event("hotbar_%s"%[i], number)
