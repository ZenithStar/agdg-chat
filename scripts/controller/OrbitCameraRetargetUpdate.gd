class_name OrbitCameraRetargetUpdate extends ControllerComponent

@onready var orbit_camera: OrbitCamera = get_parent()

func _set_target(value):
	target = value
	if target:
		var anchor = target.find_child("CameraAnchor", true, false)
		if not anchor:
			anchor = target
		if not orbit_camera._remote_anchor.is_inside_tree():
			anchor.add_child(orbit_camera._remote_anchor)
		else:
			orbit_camera._remote_anchor.reparent(anchor, false)
		orbit_camera.clear_excluded_objects()
		orbit_camera.add_excluded_object(target.get_rid())
	else:
		if orbit_camera._remote_anchor.is_inside_tree():
			orbit_camera._remote_anchor.get_parent().remove_child(orbit_camera._remote_anchor)
