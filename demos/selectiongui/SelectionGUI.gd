extends ItemList

var selection_manager: SelectionManager
var node_to_index = {}


func _on_item_activated(index: int) -> void:
	var selected = is_selected(index)
	for node in node_to_index.keys():
		if node_to_index[node] == index:
			selection_manager.select(node) if selected else selection_manager.deselect(node)
			return


func _on_selecatables_change(change: SelectionManager.SelectablesChange, node: Node) -> void:
	if change == SelectionManager.SelectablesChange.ADD:
		node_to_index[node] = add_item(node.name)
	else:
		remove_item(node_to_index[node])


func _on_selection_change(
	change: SelectionManager.SelectablesChange, node: Node
) -> void:
	if change == SelectionManager.SelectionChange.ADD:
		select(node_to_index[node])
	else:
		deselect(node_to_index[node])


func _ready():
	selection_manager = _get_selection_manager()
	if selection_manager.select_mode == SelectionManager.SelectMode.SINGLE:
		select_mode = ItemList.SELECT_SINGLE
	elif selection_manager.select_mode == SelectionManager.SelectMode.MULTI:
		select_mode = ItemList.SELECT_MULTI
	selection_manager.connect("selectables_changed", _on_selecatables_change)
	selection_manager.connect("selection_changed", _on_selection_change)
	connect("item_activated", _on_item_activated)
	for node in selection_manager.get_selectables():
		node_to_index[node] = add_item(node.name)
	


func _get_selection_manager() -> SelectionManager:
	var node = self
	while node.get_class() != "SelectionManager":
		if "%s" % node.get_path() == "/root":
			return null
		node = node.get_parent()
	return node
