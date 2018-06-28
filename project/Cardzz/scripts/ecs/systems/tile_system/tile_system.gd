extends "../system.gd"

signal tile_mouse_clicked(map_pos,world_pos,button_index)
signal tile_mouse_move(map_pos,world_pos)

const map_component_type = preload("../../components/map_component.gd")
const tile_component_type = preload("../../components/tile_component.gd")

export(Vector2) var map_size = Vector2(1024,1024)
export(Vector2) var map_offset = Vector2(512,512)

onready var tile_map = $"TileMap"
onready var tile_set = tile_map.tile_set

onready var _old_map_mouse_position = get_map_mouse_position()

func _ready():
	var water_tile_id = tile_set.find_tile_by_name("Water")
	
	for cell in tile_map.get_used_cells():
		var tile_id = tile_map.get_cellv(cell)
		if(tile_id!=water_tile_id):
			var tile_name = tile_set.tile_get_name(tile_id)
			
			var map_component = map_component_type.new()
			map_component.pos = cell			
			
			var tile_component = tile_component_type.new()
			tile_component.tile_config = $"TileConfig".get_node(tile_name)
			
			get_entity_manager().add_entity(_get_cell_name(cell),[map_component,tile_component])

func _get_cell_name(pos):
	return "tile:("+str(pos.x)+","+str(pos.y)+")"

func _process(delta):
	var map_mouse_position = get_map_mouse_position()
	if(_old_map_mouse_position!=map_mouse_position):
		var world_mouse_position = tile_map.map_to_world(map_mouse_position)
		emit_signal("tile_mouse_move",map_mouse_position,world_mouse_position)
		_old_map_mouse_position = map_mouse_position

func _input(event):
	if(event is InputEventMouseButton):
		var map_mouse_position = get_map_mouse_position()
		var world_mouse_position = tile_map.map_to_world(map_mouse_position)
		emit_signal("tile_clicked",map_mouse_position,world_mouse_position,event.button_index)

func get_map_mouse_position():
	return tile_map.world_to_map(tile_map.get_global_mouse_position())