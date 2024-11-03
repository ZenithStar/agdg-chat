extends CharacterBody3DComponent

@export var rotation_duration: float = 0.2
var _heading_xz_prop: Property
func _ready():
	if not _body.has_meta("heading_xz"):
		var new_prop = Property.new()
		new_prop._value = Vector3.ZERO
		_body.set_meta("heading_xz", new_prop)
	_heading_xz_prop = _body.get_meta("heading_xz")
@onready var _direction: Vector2 = Vector2.from_angle(_body.global_rotation.y)
func _physics_process(delta):
	var heading: Vector3 = _heading_xz_prop.value
	if heading:
		_direction = _direction.slerp(-Vector2(heading.z, heading.x).normalized(), delta/rotation_duration)
		_body.global_rotation.y = _direction.angle()

