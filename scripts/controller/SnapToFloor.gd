class_name SnapToFloor extends CharacterBody3DComponent

@export var snap_length: float = 100.0
@export var snap_queued: bool = true:
	get:
		return is_physics_processing()
	set (value):
		set_physics_process(value)

func _physics_process(_delta):
	var query = PhysicsRayQueryParameters3D.create(_body.global_position, _body.global_position+Vector3(0.0, -snap_length ,0.0))
	var result = _body.get_world_3d().direct_space_state.intersect_ray(query)
	if not result.is_empty():
		_body.global_position = result["position"]
	snap_queued = false
