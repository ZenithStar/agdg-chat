class_name ZoomCamera extends ControllerComponent

@export_group("Zoom", "zoom_")
@export_subgroup("Speed", "zoom_speed_")
@export var zoom_speed_mouse_wheel: float = 2.0 ** (1.0 / 10.0)
@export var zoom_speed_joy: float = 8.0
@export_subgroup("Clamp", "zoom_clamp_")
@export var zoom_clamp_min: float = 1.5
@export var zoom_clamp_max: float = 10.0
var zoom: float:
	get:
		return get_parent().spring_length
	set(value):
		get_parent().spring_length = clamp( value, zoom_clamp_min, zoom_clamp_max) 
		if value != zoom:
			get_parent().emit_signal("zoom_changed", zoom)
			if zoom == zoom_clamp_min:
				get_parent().emit_signal("zoom_clamp_min_limit_reached")
			elif zoom == zoom_clamp_max:
				get_parent().emit_signal("zoom_clamp_max_limit_reached")
				
func _ready():
	if not get_parent().has_user_signal("zoom_changed"):
		get_parent().add_user_signal("zoom_changed", [{ "name": "zoom", "type": TYPE_FLOAT }])
	if not get_parent().has_user_signal("zoom_clamp_min_limit_reached"):
		get_parent().add_user_signal("zoom_clamp_min_limit_reached")
	if not get_parent().has_user_signal("zoom_clamp_max_limit_reached"):
		get_parent().add_user_signal("zoom_clamp_max_limit_reached")
	set_physics_process( Input.is_action_pressed("zoom_in") or Input.is_action_pressed("zoom_out"))
		
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				zoom /= zoom_speed_mouse_wheel
				get_viewport().set_input_as_handled()
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom *= zoom_speed_mouse_wheel
				get_viewport().set_input_as_handled()
	elif event.is_action("zoom_in") or event.is_action("zoom_out"):
		set_physics_process( Input.is_action_pressed("zoom_in") or Input.is_action_pressed("zoom_out"))
				
func _physics_process(delta):
	var zoom_factor = Input.get_axis("zoom_in", "zoom_out")
	zoom *= (zoom_speed_joy ** (zoom_factor * delta))
