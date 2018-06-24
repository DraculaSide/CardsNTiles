extends Node

func _ready():
	var entity_mappers = Node.new();
	entity_mappers.name = "EntityMappers"
	add_child(entity_mappers)

func get_ecs():
	return $"../.."

func get_system_manager():
	return get_ecs().get_system_manager()

func get_entity_manager():
	return get_ecs().get_entity_manager()

func add_entity_mapper(component_types,name):
	var entity_mapper = preload("entity_mapper.gd").new()
	entity_mapper.name = name
	entity_mapper.init(component_types)
	$"EntityMappers".add_child(entity_mapper)
	pass

func get_entity_mapper(name):
	$"EntityMappers".get_node(name)

func remove_entity_mapper(name):
	$"EntityMappers".remove_child(get_entity_mapper(name))

func free_entity_mapper(name):
	get_entity_mapper(name).free_queued()