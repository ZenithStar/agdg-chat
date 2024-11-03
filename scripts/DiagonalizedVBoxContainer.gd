@tool
class_name DiagonalizedVBoxContainer extends VBoxContainer

@export_range(1./12., 1.) var SCREEN_FRACTION = 1./5.
@export_range(1./12., 1.) var FONT_FRACTION_OF_LABEL=1./3.

@export var diagonal_margin: float = 16.0:
	set(value):
		diagonal_margin = value
		queue_sort()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_SORT_CHILDREN:
			var i = 0
			for child in get_children():
				if child is Control:
					child.position.x += diagonal_margin * i 
					i += 1
					

func _ready():	
	if not Engine.is_editor_hint():
		_update_size()
		get_viewport().size_changed.connect(_update_size)
func _update_size():
	if not Engine.is_editor_hint():
		## keep on screen
		if is_inside_tree():
			# keep in mind this is tool script, runs inside editor too!!!
			if global_position.y + size.y > get_viewport_rect().size.y :
				global_position.y = get_viewport_rect().size.y - size.y
		## rescale to new screen size
		var vpr : Vector2 = get_viewport_rect().size
		size.x = vpr.x * SCREEN_FRACTION
		for child in get_children():
			#print(child)
			(child as Control).custom_minimum_size.y = vpr.y*SCREEN_FRACTION/get_child_count()
			(child as Control).set("theme_override_font_sizes/font_size", (vpr.y*SCREEN_FRACTION/get_child_count()*FONT_FRACTION_OF_LABEL))
