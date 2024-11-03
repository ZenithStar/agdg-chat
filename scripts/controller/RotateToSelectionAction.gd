class_name RotateToSelectionAction extends CharacterBody3DComponent

@export var xz_locked: bool = true

var _target_property: Property

func _ready():
	if not get_parent().has_meta("focus_target"):
		get_parent().set_meta("focus_target", Property.new())
	_target_property = get_parent().get_meta("focus_target")
	_target_property.changed.connect(check_enable)
	check_enable()

func check_enable():
	set_physics_process(_target_property.value != null)
	$"../RotateToHeadingAction".set_physics_process(_target_property.value == null)

func _physics_process(delta):
	if xz_locked:
		var heading_forward = _target_property.value.global_position - _body.global_position
		_body.global_rotation.y = atan2(-heading_forward.x, -heading_forward.z)
