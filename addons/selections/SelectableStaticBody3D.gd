extends StaticBody3D


func _input_event(
		_camera: Object,
		event: InputEvent,
		_click_position: Vector3,
		_click_normal: Vector3,
		_shape_idx: int
	) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		print("Selected")
