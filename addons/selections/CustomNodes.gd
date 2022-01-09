@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type(
		"SelectionManager",
		"Node",
		preload("res://addons/selections/SelectionManager.gd"),
		null
	)


func _exit_tree() -> void:
	remove_custom_type("SelectionManager")
