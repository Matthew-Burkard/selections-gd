extends Node

var selected: bool = false


func set_selected(is_selected: bool) -> void:
	selected = is_selected
	on_selection() if is_selected else on_deselection()


func on_selection() -> void:
	"""Override this method to determine behavior when seletcted."""
	pass


func on_deselection() -> void:
	"""Override this method to determine behavior when deletcted."""
	pass
