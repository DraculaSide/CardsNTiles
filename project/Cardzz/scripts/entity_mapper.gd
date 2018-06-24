extends Node

var component_types
var entitys = []

func init(component_types):
	self.component_types = component_types
	entitys = get_entity_manager().get_entities_with_components(component_types)
	
	get_entity_manager().connect_signal("add_entity",self,"_add_entity")
	for entity in entitys:
		entity.connect_signal("removed",self,"remove_entity",[entity])
	for entity in get_entity_manager().get_entities():
		entity.connect_signal("add_component",self,"_add_component")
		for component_type in component_types:
			for component in entity.get_components():
				component.connect_signal("removed",self,"remove_entity",[entity])

func get_ecs():
	$"../../../.."

func get_system_manager():
	return get_ecs().get_system_manager()

func get_entity_manager():
	return get_ecs().get_entity_manager()

func _add_component(component):
	_add_entity(component.get_entity());

func _add_entity(entity):
	if(entity.has_components(component_types)):
		entitys.append(entity)

func _remove_entity(entity):
	entitys.erase(entity)
