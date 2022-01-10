class_name SelectionManager
extends Node

enum SelectablesChange {
	ADD,
	REMOVE
}

enum SelectionChange {
	ADD,
	REMOVE
}

enum SelectionMode {
	SINGLE,
	MULTIPLE
}

enum MultiSelectKey {
	CTRL = KEY_CTRL,
	SHIFT = KEY_SHIFT
}

signal selection_changed(change: SelectionChange, target: Node)
signal selectables_changed(change: SelectablesChange, target: Node)

@export var selection_mode: SelectionMode = SelectionMode.MULTIPLE
@export var multi_select_key: MultiSelectKey = MultiSelectKey.CTRL

var _selectables: Array = []
var _selections: Array = []
var _deselect_all: bool = true


func get_class() -> String:
	return "SelectionManager"


func activate(target: Node) -> bool:
	var is_selected = _selections.has(target)
	if selection_mode == SelectionMode.SINGLE:
		if is_selected:
			deselect(target)
			return false
		_reselect([target])
		return true

	var multi_select_pressed = Input.is_key_pressed(multi_select_key)
	if multi_select_pressed and is_selected:
		deselect(target)
		return false
	if multi_select_pressed:
		select(target)
		return true
	_reselect([target])
	return true


func get_selectables() -> Array:
	return _selectables


func register(node: Node) -> void:
	if not _selectables.has(node):
		_selectables.append(node)
		emit_signal("selectables_changed", SelectablesChange.ADD, node)


func unregister(node: Node) -> void:
	if _selectables.has(node):
		_selectables.erase(node)
		emit_signal("selectables_changed", SelectablesChange.REMOVE, node)


func select(target: Node) -> void:
	_deselect_all = false
	_selections.append(target)
	if target.has_method("on_select"):
		target.on_select()
	emit_signal("selection_changed", SelectionChange.ADD, target)


func deselect(target: Node) -> void:
	_deselect_all = false
	_selections.erase(target)
	if target.has_method("on_deselect"):
		target.on_deselect()
	emit_signal("selection_changed", SelectionChange.REMOVE, target)


func _unhandled_input(event) -> void:
	var multi_select_pressed = Input.is_key_pressed(multi_select_key)
	# If left mouse button pressed set _deselect_all to true.
	# If left button released and nothing has been added/removed, deselect all.
	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		var is_multi = (multi_select_pressed and selection_mode == SelectionMode.MULTIPLE)
		if event.pressed and not is_multi:
			_deselect_all = true
		# SelectionManager may need an "active" variable to prevent this from
		# being triggered by out of scope unhandled inputs.
		elif _deselect_all:
			_reselect([])
			_deselect_all = false


func _reselect(new_selection: Array) -> void:
	var all_selections = _selections.duplicate()
	for node in all_selections:
		if not new_selection.has(node):
			deselect(node)
	for node in new_selection:
		if not _selections.has(node):
			select(node)
