class_name CameraParameters extends Resource

@export_flags_3d_render var cull_mask: int = 1048575

@export var attributes: CameraAttributesPractical:
	set(value):
		attributes = value
		emit_changed()
		attributes.changed.connect(emit_changed)

@export var h_offset: float = 0.0
@export var v_offset: float = 0.0
@export var fov: float = 75.0
@export var near: float = 0.05
@export var far: float = 4000.0

func _init() -> void:
	if attributes:
		attributes.changed.connect(emit_changed)

func apply_to(camera: Camera3D, other: CameraParameters = null , weight: float = 0.0):
	if other:
		camera.cull_mask = cull_mask | other.cull_mask
		camera.h_offset = lerpf( h_offset, other.h_offset, weight)
		camera.v_offset = lerpf( v_offset, other.v_offset, weight)
		camera.fov = lerpf( fov, other.fov, weight)
		camera.near = lerpf( near, other.near, weight)
		camera.far = lerpf( far, other.far, weight)
	else:
		camera.attributes = attributes
		camera.cull_mask = cull_mask
		camera.h_offset = h_offset
		camera.v_offset = v_offset
		camera.fov = fov
		camera.near = near
		camera.far = far
