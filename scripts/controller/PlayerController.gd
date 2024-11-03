class_name PlayerController extends Node

signal control_target_changed
@export var control_target: Node:
	set(value):
		control_target = value
		control_target_changed.emit()

var _control_groups: Array[Node]

@onready var camera: Camera3D = $PlayerCamera

func _ready() -> void:
	_update_control_groups()
	_on_control_target_changed()
	control_target_changed.connect(_on_control_target_changed)
		
func _on_control_target_changed():
	if is_instance_valid(control_target):
		_control_groups[0].camera_setpoint.push_to.append(camera)
	else:
		pass 
	

func _sort_by_priority(a,b) -> bool:
	return a.priority > b.priority

func _update_control_groups():
	_control_groups = []
	for child in get_children():
		if child is ControlGroup:
			_control_groups.append(child)
	_control_groups.sort_custom(_sort_by_priority)
