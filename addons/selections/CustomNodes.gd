@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type(
		"SelectionManager",
		"Node3D",
		preload("res://addons/selections/SelectionManager.gd"),
		null
	)


func _exit_tree() -> void:
	remove_custom_type("SelectableStaticBody3D")
	remove_custom_type("SelectionManager")
