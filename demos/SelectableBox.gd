extends StaticBody3D

const select_shader = preload("res://demos/shaders/selected/selected_material.tres")
const normal_shader = preload("res://demos/shaders/normal/normal_material.tres")
var selection_manager: SelectionManager

func on_select() -> void:
	$BoxMesh.set_material_override(select_shader)


func on_deselect() -> void:
	$BoxMesh.set_material_override(normal_shader)


func _ready() -> void:
	selection_manager = _get_selection_manager()


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
		selection_manager.activate(self)


func _get_selection_manager() -> SelectionManager:
	var node = self
	while node.get_class() != "SelectionManager":
		if "%s" % node.get_path() == "/root":
			return null
		node = node.get_parent()
	return node
