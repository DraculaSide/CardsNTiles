tool
extends EditorScript

func _run():
	var tile_system = get_scene().get_node("Systems/TileSystem")
	var tile_map = tile_system.get_node("TileMap")
	var tile_set = tile_map.tile_set
	var water_tile_id = tile_set.find_tile_by_name("Water")
	
	for tile in tile_map.get_used_cells_by_id(water_tile_id):
		tile_map.set_cellv(tile,-1)
	
	for x in range(tile_system.map_size.x):
		for y in range(tile_system.map_size.y):
			if(tile_map.get_cell(x-tile_system.map_offset.x,y-tile_system.map_offset.y)<0):
				tile_map.set_cell(x-tile_system.map_offset.x,y-tile_system.map_offset.y,water_tile_id)
	