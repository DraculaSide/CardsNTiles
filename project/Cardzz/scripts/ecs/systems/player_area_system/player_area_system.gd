extends "../system.gd"

signal add_area(pos,player)
signal remove_area(pos,player)

const map_entity_mapper_type = preload("../map_entity_mapper.gd")
const map_component_type = preload("../../components/map_component.gd")
const player_area_component_type = preload("../../components/player_area_component.gd")
const tile_component_type = preload("../../components/tile_component.gd")
const owner_conponent_type = preload("../../components/owner_component.gd")
const player_component_type = preload("../../components/player_component.gd")

onready var tile_map = $"PlayerArea"
onready var tile_set = tile_map.tile_set
var colors = []

func _ready():
	var player_areas = add_custom_entity_mapper(map_entity_mapper_type,
		[map_component_type,structure_component_type,owner_conponent_type],"structures")
	
	var tiles = add_custom_entity_mapper(map_entity_mapper_type,
		[map_component_type,tile_component_type],"tiles")
	
	player_areas.connect("add_entity",self,"_add_player_area")
	player_areas.connect("remove_entity",self,"_remove_player_area")
	
	for player_area in player_areas.get_entitys:
		_add_player_area(player_area)
	
	for tile_id in tile_set.get_tile_ids():
		colors.append(tile_set.tile_get_name(tile_id)) 

func get_colors():
	return colors

func _add_player_area(player_area):
	player_area.connect("dist_changed",self,"_update_player_area",[player_area])
	
	var map_component = player_area.get_component(map_component_type)
	var player_area_component = player_area.get_component(player_area_component_type)
	var owner_component = player_area.get_component(owner_conponent_type)
	var player_component = owner_component.player.get_component(player_component_type)
	var color_id = tile_set.find_tile_by_name(player_component.color) 
	_add_area(map_component,player_area_component.dist,color_id,owner_component.player)

func _remove_player_area(player_area):
	player_area.disconnect("dist_changed",self,"_update_player_area",[player_area])
	
	var map_component = player_area.get_component(map_component_type)
	var player_area_component = player_area.get_component(player_area_component_type)
	var owner_component = player_area.get_component(owner_conponent_type)
	_remove_area(map_component,player_area_component.dist,owner_component.player)
	pass

func _update_player_area(old_dist,new_dist,player_area):
	var map_component = player_area.get_component(map_component_type)
	var player_area_component = player_area.get_component(player_area_component_type)
	var owner_component = player_area.get_component(owner_conponent_type)
	var player_component = owner_component.player.get_component(player_component_type)
	var color_id = tile_set.find_tile_by_name(player_component.color) 
	
	_remove_area(map_component,old_dist,owner_component.player)
	_add_area(map_component,new_dist,color_id,owner_component.player)

func _add_area(map_component,dist,color_id,player):
	for pos in map_component.area(dist):
		tile_map.set_cellv(pos,color_id)
		emit_signal("add_area",pos,player)

func _remove_area(map_component,dist,player):
	for pos in map_component.area(dist):
		tile_map.set_cellv(pos,-1)
		emit_signal("remove_area",pos,player)
