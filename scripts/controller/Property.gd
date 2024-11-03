class_name Property extends RefCounted

signal changed
var _value
var value:
	get:
		return _getter.call()
	set(value):
		return _setter.call(value)
var _getter: Callable
var _setter: Callable

func _default_get():
	return _value
func _default_set(new_value):
	if _value != new_value:
		_value = new_value
		changed.emit()
func _init(fget=_default_get, fset=_default_set):
	_getter = fget
	_setter = fset
