extends Node

var entitys = []
var component_types

func init(component_types):
	self.component_types = component_types
	var entitys = get_entity_manager().get_entities_with_components(component_types)
	for entity in entitys:
		_add_entity(entity)
	
	get_entity_manager().connect("add_entity",self,"_rec_add_entity")
	get_entity_manager().connect("remove_entity",self,"_rec_remove_entity")
	for entity in get_entity_manager().get_entities():
		entity.connect("add_component",self,"_rec_add_component")
		entity.connect("remove_component",self,"_rec_remove_component")

func get_ecs():
	$"../../../.."

func get_system_manager():
	return get_ecs().get_system_manager()

func get_entity_manager():
	return get_ecs().get_entity_manager()

func _rec_add_component(component):
	var entity = component.get_entity()
	if(!entitys.has(entity)):
		if(entity.has_components(component_types)):
			entitys.append(entity)
			_add_entity(entity)

func _rec_add_entity(entity):
	entity.connect("add_component",self,"_rec_add_component")
	entity.connect("remove_component",self,"_rec_remove_component")
	if(!entitys.has(entity)):
		if(entity.has_components(component_types)):
			entitys.append(entity)
			_add_entity(entity)

func _rec_remove_component(component):
	var entity = component.get_entity()
	if(entitys.has(entity)):
		if(!entity.has_components(component_types)):
			entity.erase(entity)
			_remove_entity(entity)

func _rec_remove_entity(entity):
	if(entitys.has(entity)):
		entity.erase(entity)
		_remove_entity(entity)

func _add_entity(entity):
	pass

func _remove_entity(entity):
	pass

func _get_entitys():
	return entitys
