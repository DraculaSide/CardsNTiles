extends "entity_mapper.gd"

var map_component_type = preload("../components/map_component.gd")
var entity_map = {}

func _add_entity(entity):
	var map_component = entity.get_component(map_component_type)
	entity_map[map_component.pos] = entity

func _remove_entity(entity):
	var map_component = entity.get_component(map_component_type)
	entity_map.erase(map_component.pos)
	