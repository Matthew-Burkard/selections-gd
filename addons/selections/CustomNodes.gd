extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type(
		"SelectableStaticBody3D",
		"StaticBody3D",
		preload("res://addons/selections/SelectableStaticBody3D.gd"),
		null
	)


func _exit_tree() -> void:
	remove_custom_type("SelectableStaticBody3D")
