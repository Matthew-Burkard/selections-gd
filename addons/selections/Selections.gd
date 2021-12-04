extends Node

const Context = preload("res://addons/selections/Context.gd")

var _contexts: Dictionary = {}


func get_context(name: String) -> Context:
	var context = _contexts[name]
	if context == null:
		context = Context.new()
		_contexts[name] = context
	return context
