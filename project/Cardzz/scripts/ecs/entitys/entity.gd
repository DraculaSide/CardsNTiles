extends Node

signal added
signal removed

signal add_component(component)
signal remove_component(component)

func get_component(type):
	for child in get_children():
		if(child is type):
			return child

func get_components(type):
	var components = []
	for child in get_children():
		if(child is type):
			components.append(child)
	return components

func has_component(type):
	for child in get_children():
		if(child is type):
			return true
	return false

func has_components(types):
	for type in types:
		if(not has_component(type)):
			return false
	return true

func get_all_components():
	return get_children()

func add_component(component):
	add_child(component)
	emit_signal("add_component",component)
	component.emit_signal("added")

func remove_component(component):
	component.emit_signal("removed")
	emit_signal("remove_component",component)
	component.queue_free()
