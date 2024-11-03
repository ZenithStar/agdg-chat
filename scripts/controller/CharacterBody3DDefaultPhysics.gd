class_name CharacterBody3DDefaultPhysics extends CharacterBody3DComponent


@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var coefficent_of_drag: float = 0

func _ready():
	if not _body.has_user_signal("floor_entered"):
		_body.add_user_signal("floor_entered", [{ "name": "velocity", "type": TYPE_FLOAT }])
	if not _body.has_user_signal("floor_exited"):
		_body.add_user_signal("floor_exited", [{ "name": "velocity", "type": TYPE_FLOAT }])
	if not _body.is_multiplayer_authority():
		set_physics_process(false)

func _physics_process(delta):
	var was_on_floor = _body.is_on_floor()
	if not _body.is_on_floor():
		_body.velocity.y -= gravity * delta
	var air_resistance = - _body.velocity.normalized() * coefficent_of_drag * _body.velocity.length_squared() * delta
	_body.velocity += air_resistance
	_body.move_and_slide()
	if was_on_floor and not _body.is_on_floor():
		_body.emit_signal("floor_exited", _body.get_real_velocity().y)
	elif not was_on_floor and _body.is_on_floor():
		_body.emit_signal("floor_entered", _body.get_real_velocity().y)
