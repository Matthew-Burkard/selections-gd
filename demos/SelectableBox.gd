extends StaticBody3D


func on_select() -> void:
	print("box selected")


func on_deselect() -> void:
	print("box deselected")


func _input_event(
	_camera: Object,
	event: InputEvent,
	_click_position: Vector3,
	_click_normal: Vector3,
	_shape_idx: int
) -> void:
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		var manager: SelectionManager = _get_selection_manager()
		if manager != null:
			manager.toggle(self)
		else:
			# TODO Logger.
			print("warn: no SelectionManager found.")


func _get_selection_manager() -> SelectionManager:
	var node = self
	while node.get_class() != "SelectionManager":
		if "%s" % node.get_path() == "/root":
			return null
		node = node.get_parent()
	return node
