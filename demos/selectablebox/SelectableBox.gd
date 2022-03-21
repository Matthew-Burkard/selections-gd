extends StaticBody3D

@onready var box_mesh = $BoxMesh

const select_shader = preload("res://demos/materials/selected/selected_material.tres")
const normal_shader = preload("res://demos/materials/normal/normal_material.tres")
var selection_manager: SelectionManager

func on_select() -> void:
	box_mesh.set_material_override(select_shader)


func on_deselect() -> void:
	box_mesh.set_material_override(normal_shader)


func _ready() -> void:
	selection_manager = _get_selection_manager()
	selection_manager.register(self)


func _input_event(
	_camera: Camera3D,
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
	while not node is SelectionManager:
		if "%s" % node.get_path() == "/root":
			return null
		node = node.get_parent()
	return node
