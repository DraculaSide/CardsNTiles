extends Node

var component_types

func init(component_types):
	self.component_types = component_types
	var entitys = get_entity_manager().get_entities_with_components(component_types)
	for entity in entitys:
		_add_entity(entity)
	
	get_entity_manager().connect("add_entity",self,"_rec_add_entity")
	for entity in get_entity_manager().get_entities():
		entity.connect("add_component",self,"_rec_add_component")

func get_ecs():
	$"../../../.."

func get_system_manager():
	return get_ecs().get_system_manager()

func get_entity_manager():
	return get_ecs().get_entity_manager()

func _rec_add_component(component):
	var entity = component.get_entity()
	if(entity.has_components(component_types)):
		_add_entity(entity)

func _rec_add_target_component(component):
	for component_type in component_types:
		if(component is component_type):
			 component.connect("removed",self,"_rec_remove_component",[component])

func _rec_add_entity(entity):
	entity.connect("add_component",self,"_rec_add_component")
	if(entity.has_components(component_types)):
		_add_entity(entity)

func _rec_remove_component(component):
	var entity = component.get_entity()
	if(centity.has_components(component_types)):
		_remove_entity(entity)
	else:
		component.disconnect("removed",self,"_rec_remove_component")

func _rec_remove_entity(entity):
	entity.disconnect("add_component",self,"_rec_add_component")
	_remove_entity(entity)

func _add_entity(entity):
	entity.connect("add_component",self,"_rec_add_target_component")
	entity.connect("removed",self,"_rec_remove_entity",[entity])
	for component_type in component_types:
		for component in entity.get_components(component_type):
			component.connect("removed",self,"_rec_remove_component",[component])
	pass

func _remove_entity(entity):
	entity.disconnect("add_component",self,"_rec_add_target_component")
	entity.disconnect("removed",self,"_rec_remove_entity")
	for component_type in component_types:
		for component in entity.get_components(component_type):
			component.disconnect("removed",self,"_rec_remove_component")
	pass

func _get_entitys():
	pass
