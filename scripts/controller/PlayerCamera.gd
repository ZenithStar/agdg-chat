class_name PlayerCamera extends Camera3D

@export var setpoint: CameraSetpoint :
	set(value):
		setpoint = value
		set_process(setpoint != null)

func _ready() -> void:
	set_process(setpoint != null)
