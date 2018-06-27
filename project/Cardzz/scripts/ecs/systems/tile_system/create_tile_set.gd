tool
extends EditorScript

func _run():
	var tile_set = TileSet.new()
	var tile_config_node = get_scene().get_node("Systems/TileSystem/TileConfig")
	for tile_config in tile_config_node.get_children():
		var id = tile_set.get_last_unused_tile_id()
		tile_set.create_tile(id)
		tile_set.tile_set_name(id,tile_config.name)
		tile_set.tile_set_texture(id,tile_config.texture)
		tile_set.tile_set_texture_offset(id,Vector2(0,-8))
	get_scene().get_node("Systems/TileSystem/TileMap").tile_set = tile_set