extends Node
class_name SelectionManager

enum SelectablesChange {
	ADD,
	REMOVE
}

enum SelectionChange {
	ADD,
	REMOVE
}

enum SelectMode {
	SINGLE,
	MULTI
}

enum MultiSelectKey {
	CTRL = KEY_CTRL,
	SHIFT = KEY_SHIFT
}

signal selection_changed(change: SelectionChange, target: Node)
signal selectables_changed(change: SelectablesChange, node: Node)

@export var select_mode: SelectMode = SelectMode.MULTI
@export var multi_select_key: MultiSelectKey = MultiSelectKey.CTRL

var _selectables: Array = []
var _selections: Array = []
var _deselect_all: bool = true


## Activate a selectable Node.
##
## @desc:
##     If "select_mode" is Single, toggle the selection state of this node
##     and deselect any other selected node.
func activate(target: Node) -> bool:
	var is_selected = _selections.has(target)
	if select_mode == SelectMode.SINGLE:
		if is_selected:
			deselect(target)
			return false
		set_selection([target])
		return true

	var multi_select_pressed = Input.is_key_pressed(multi_select_key)
	if multi_select_pressed and is_selected:
		deselect(target)
		return false
	if multi_select_pressed:
		select(target)
		return true
	set_selection([target])
	return true


## Get all Nodes registered as selectable with this SelectionManager.
func get_selectables() -> Array:
	return _selectables


## Register a node as being selectable.
##
## @desc:
##     Emits the "selectables_changed" signal.
func register(node: Node) -> void:
	if not _selectables.has(node):
		_selectables.append(node)
		emit_signal("selectables_changed", SelectablesChange.ADD, node)


## Unregister a node as being selectable.
func unregister(node: Node) -> void:
	if _selectables.has(node):
		_selectables.erase(node)
		emit_signal("selectables_changed", SelectablesChange.REMOVE, node)


## Select the given node.
##
## @desc:
##     If the node has an "on_select" method defined, it will be called.
##     Emits the "selection_changed" signal.
func select(node: Node, multi: bool = false) -> void:
	_deselect_all = false
	_selections.append(node)
	if node.has_method("on_select"):
		node.on_select()
	emit_signal("selection_changed", SelectionChange.ADD, node)


## Deselect the given node.
##
## @desc:
##     If the node has an "on_deselect" method defined, it will be called.
##     Emits the "selection_changed" signal.
func deselect(node: Node) -> void:
	_deselect_all = false
	_selections.erase(node)
	if node.has_method("on_deselect"):
		node.on_deselect()
	emit_signal("selection_changed", SelectionChange.REMOVE, node)

## Set the given Array of Nodes as selected.
##
## @desc:
##     Select each Node in the Array if it's not already selected.
##     Deselect any nodes that are selected but not in the Array.
##     The "selection_changed" signal will be emitted for any selection changes.
func set_selection(new_selection: Array) -> void:
	var all_selections = _selections.duplicate()
	for node in all_selections:
		if not new_selection.has(node):
			deselect(node)
	for node in new_selection:
		if not _selections.has(node):
			select(node)


func _unhandled_input(event) -> void:
	var multi_select_pressed = Input.is_key_pressed(multi_select_key)
	# If left mouse button pressed set _deselect_all to true.
	# If left button released and nothing has been added/removed, deselect all.
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		var is_multi = (multi_select_pressed and select_mode == SelectMode.MULTI)
		if event.pressed and not is_multi:
			_deselect_all = true
		# SelectionManager may need an "active" variable to prevent this from
		# being triggered by out of scope unhandled inputs.
		elif _deselect_all:
			set_selection([])
			_deselect_all = false
