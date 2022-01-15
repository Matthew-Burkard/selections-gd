extends ItemList

var selection_manager: SelectionManager
var _node_to_index = {}


func _on_multi_selected(index: int, selected: bool) -> void:
	if selected:
		if get_selected_items().size() > 1:
			selection_manager.select(get_item_metadata(index))
		else:
			selection_manager.set_selection([get_item_metadata(index)])
	else:
		selection_manager.deselect(get_item_metadata(index))


func _on_item_selected(index: int) -> void:
	selection_manager.set_selection([get_item_metadata(index)])


func _on_selectables_change(
	change: SelectionManager.SelectablesChange, node: Node
) -> void:
	if change == SelectionManager.SelectablesChange.ADD:
		_node_to_index[node] = add_item(node.name)
		set_item_metadata(_node_to_index[node], node)
	else:
		remove_item(_node_to_index[node])


func _on_selection_change(
	change: SelectionManager.SelectablesChange, node: Node
) -> void:
	if change == SelectionManager.SelectionChange.ADD:
		select(_node_to_index[node], false)
	else:
		deselect(_node_to_index[node])


func _ready():
	selection_manager = _get_selection_manager()
	if selection_manager.select_mode == SelectionManager.SelectMode.SINGLE:
		select_mode = ItemList.SELECT_SINGLE
	elif selection_manager.select_mode == SelectionManager.SelectMode.MULTI:
		select_mode = ItemList.SELECT_MULTI
	selection_manager.connect("selectables_changed", _on_selectables_change)
	selection_manager.connect("selection_changed", _on_selection_change)
	connect("item_selected", _on_item_selected)
	connect("multi_selected", _on_multi_selected)
	for node in selection_manager.get_selectables():
		_node_to_index[node] = add_item(node.name)
		set_item_metadata(_node_to_index[node], node)


func _get_selection_manager() -> SelectionManager:
	var node = self
	while not node is SelectionManager:
		if "%s" % node.get_path() == "/root":
			return null
		node = node.get_parent()
	return node
