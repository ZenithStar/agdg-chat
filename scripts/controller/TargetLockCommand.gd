class_name TargetLockCommand extends Area3D

@export var target_input: String = "target"
@export var cancel_target: String = "pause"

signal target_changed
var _current_target: CharacterBody3D = null:
	set(value):
		_current_target = value
		if target_prop:
			target_prop.value = value
		target_changed.emit()
		

var target: Node = null:
	set(value):
		if _current_target:
			_current_target = null
		target = value
		if target:
			if not target.has_meta("focus_target"):
				target.set_meta("focus_target", Property.new())
			target_prop = target.get_meta("focus_target")
		else:
			target_prop = null
var target_prop: Property = null

func _ready():
	get_parent().follow_target_changed.connect(configure)
	configure()
	body_exited.connect(_on_body_exited)
	
func configure():
	target = get_parent().get_follow_target_node()
	
func _on_body_exited(body: Node3D):
	if body == _current_target:
		_current_target = null
func _notification(what):
	match what:
		NOTIFICATION_DISABLED:
			if target_prop:
				_current_target = null
func _unhandled_input(event: InputEvent):
	if event.is_action(target_input) and not event.is_echo():
		if event.is_pressed():
			var bodies = get_overlapping_bodies()
			var current_index = bodies.find(_current_target if _current_target else target)
			for i in range(1, bodies.size()):
				var this = bodies[(current_index + i) % bodies.size()]
				if this is CharacterBody3D: # change to a targetable component in the future?
					_current_target = this if this != target else null
					get_viewport().set_input_as_handled()
					return
	if event.is_action(cancel_target) and not event.is_echo():
		if event.is_pressed():
			_current_target = null
