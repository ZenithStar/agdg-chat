class_name Interactable extends Node

@export var interaction_tooltip: String = ""

func _ready():
	get_parent().set_meta("interaction_tooltip", interaction_tooltip)
