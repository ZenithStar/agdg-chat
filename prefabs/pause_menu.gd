extends Control

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ESCAPE and event.pressed and not event.is_echo():
			visible = ! visible

func _on_game_pressed() -> void:
	visible = false


func _on_title_pressed() -> void:
	multiplayer.multiplayer_peer.disconnect_peer(multiplayer.get_unique_id())
	visible = false


func _on_quit_pressed() -> void:
	get_tree().quit()
