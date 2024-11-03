class_name ControllerComponent extends Node

@onready var controller: PlayerController = _find_controller()

var target: Node = null: set = _set_target

func _set_target(value):
	target = value

func _ready():
	configure()
	controller.control_target_changed.connect(configure)

func configure():
	target = controller.control_target

func _recursive_find_controller(node: Node) -> PlayerController:
	if node is PlayerController:
		return node
	elif node == get_tree().root:
		return null
	else:
		return _recursive_find_controller(node.get_parent())

func _find_controller() -> PlayerController:
	if is_inside_tree():
		return _recursive_find_controller(get_parent())
	else:
		return null

## This doesn't do anything if this isn't a tool script
func _get_configuration_warnings() -> PackedStringArray:
	var output = []
	if not _find_controller():
		output.append("%s requires a PlayerController ancestor"%[get_script().get_global_name()])
	return PackedStringArray(output)
	
#func _notification(what):
	#match what:
		#NOTIFICATION_PARENTED:
			#update_configuration_warnings ( )
			#controller = _find_controller()
			#print(controller)
			#if not controller:
				#push_error("%s requires a PlayerController ancestor"%[get_script().get_global_name()])
