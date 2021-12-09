# Use to manage selectable Nodes.
class_name SelectionManager
extends Node

enum SelectionChange {
	ADD,
	REMOVE
}

enum SelectionMode {
	SINGLE,
	MULTIPLE
}

signal selection_changed(change: SelectionChange, target: Node)

var mode: SelectionMode = SelectionMode.MULTIPLE
var _selections: Array = []
var _deselect_all: bool = true


func add(target: Node) -> void:
	_deselect_all = false
	if "set_selected" in target:
		target.set_selected(true)
	_selections.append(target)
	emit_signal("selection_changed", SelectionChange.ADD, target)


func remove(target: Node) -> void:
	_deselect_all = false
	if "set_selected" in target:
		target.set_selected(false)
	_selections.erase(target)
	emit_signal("selection_changed", SelectionChange.REMOVE, target)


func _unhandled_input(event) -> void:
	# If left mouse button pressed set _deselect_all to true.
	# If left button released and nothing has been added/removed, deselect all.
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_deselect_all = true
		elif _deselect_all:
			_reselect([])
			_deselect_all = false


func _reselect(new_selection: Array) -> void:
	var all_selections = _selections.duplicate()
	for node in all_selections:
		if not new_selection.has(node):
			remove(node)
