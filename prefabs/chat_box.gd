extends Control

@export var chat_history_limit: int = 0

func _ready():
	$Panel/ChatHistory.clear()
	

@export var intrusive: bool = false:
	set(value):
		intrusive = value
		$Panel/ChatHistory.mouse_filter = MOUSE_FILTER_STOP if intrusive else MOUSE_FILTER_IGNORE
@export var fade_delay: float = 5.0
@export var fade_duration: float = 1.0

@export var alpha: float:
	get:
		return material.get_shader_parameter("alpha")
	set(value):
		material.set_shader_parameter("alpha", value)
@export var history_alpha: float:
	get:
		return $Panel/ChatHistory.material.get_shader_parameter("alpha")
	set(value):
		$Panel/ChatHistory.material.set_shader_parameter("alpha", value)

var _fade_tween: Tween
var _nonintrusive_fade_tween: Tween
@export var fade_show: bool:
	get:
		return $ChatInput.visible
	set(value):
		if is_instance_valid(_fade_tween):
			_fade_tween.kill()
		if is_instance_valid(_nonintrusive_fade_tween):
			_nonintrusive_fade_tween.kill()
		if value:
			intrusive = true
			$ChatInput.visible = true
			alpha = 1.0
			history_alpha = 1.0
		elif $ChatInput.visible and not value:
			intrusive = false
			$ChatInput.visible = false
			_fade_tween = create_tween()
			_fade_tween.tween_interval(fade_delay)
			_fade_tween.tween_property(self, "alpha", 0.0, fade_duration)
			_fade_tween.tween_property($ChatInput, "visible", false, 0.0)
			_nonintrusive_fade_tween = create_tween()
			_nonintrusive_fade_tween.tween_interval(fade_delay)
			_nonintrusive_fade_tween.tween_property(self, "history_alpha", 0.0, fade_duration)

func _on_focus_exited() -> void:
	if get_viewport().gui_get_focus_owner() != $ChatInput and get_viewport().gui_get_focus_owner() != $Panel/ChatHistory:
		intrusive = false
		fade_show = false

func _on_focus_entered() -> void:
	intrusive = true
	fade_show = true

func push_message( message: String ):
	$Panel/ChatHistory.append_text(message)
	history_alpha = 1.0
	if not intrusive:
		if is_instance_valid(_nonintrusive_fade_tween):
			_nonintrusive_fade_tween.kill()
		_nonintrusive_fade_tween = create_tween()
		_nonintrusive_fade_tween.tween_interval(fade_delay)
		_nonintrusive_fade_tween.tween_property(self, "history_alpha", 0.0, fade_duration)
