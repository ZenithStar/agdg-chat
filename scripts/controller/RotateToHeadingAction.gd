class_name RotateToHeadingAction extends CharacterBody3DComponent

@export var always_rotate: bool = false ## If false, only rotate when heading is non-zero

var _heading_xz_prop: Property
var _heading_xz_forward_prop: Property

func _ready():
	if not get_parent().has_meta("heading_xz"):
		get_parent().set_meta("heading_xz", Property.new())
	if not get_parent().has_meta("heading_xz_forward"):
		get_parent().set_meta("heading_xz_forward", Property.new())
	_heading_xz_prop = get_parent().get_meta("heading_xz")
	_heading_xz_forward_prop = get_parent().get_meta("heading_xz_forward")

func _physics_process(_delta):
	var heading = _heading_xz_prop.value
	var heading_forward = _heading_xz_forward_prop.value
	if (always_rotate or heading) and heading_forward != null:
		_body.global_rotation.y = atan2(-heading_forward.x, -heading_forward.z)
