class_name SelectableStaticBody3D
extends StaticBody3D

const SelectionManager = preload("res://addons/selections/SelectionManager.gd")


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
		var selected = manager.toggle(self)


func _get_selection_manager() -> SelectionManager:
	var node = self
	while node.get_class() != "SelectionManager":
		node = node.get_parent()
	return node
