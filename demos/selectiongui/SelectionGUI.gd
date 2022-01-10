extends Control

var selection_manager: SelectionManager


func _ready():
	selection_manager = _get_selection_manager()


func _get_selection_manager() -> SelectionManager:
	var node = self
	while node.get_class() != "SelectionManager":
		if "%s" % node.get_path() == "/root":
			return null
		node = node.get_parent()
	return node
