extends "component.gd"

signal pos_changed(old_pos,new_pos)

var pos setget set_pos

func set_pos(new_pos):
	emit_signal("pos_changed",pos,new_pos)
	pos = new_pos

const _oddr_directions = [
    [[+1,  0], [ 0, -1], [-1, -1], 
     [-1,  0], [-1, +1], [ 0, +1]],
    [[+1,  0], [+1, -1], [ 0, -1], 
     [-1,  0], [ 0, +1], [+1, +1]],
]

func neighbors():
	return _neighbors(pos)

func axial():
	return _axial(pos)

func cube():
	return _cube(pos)

func dist(other_pos):
	return _dist(pos,other_pos)

func area(dist):
	var area = []
	var size = dist*2+1
	for y in range(size):
		for x in range(size):
			var offset_pos = Vector2(x+pos.x-dist,y+pos.y-dist)
			if(dist(offset_pos)<=dist):
				area.append(offset_pos)
	return area

func _cube(p):
	var x = p.x - (p.y - (p.y&1)) / 2
	var z = p.y
	var y = -x-z
	return Vector3(x, y, z)

func _axial(p):
	var x = p.x - (p.y - (p.y&1)) / 2
	var z = p.y
	return Vector2(x,z)

func _neighbors():
	var parity = pos.y & 1
	return _oddr_directions[parity]

func _dist(p1,p2):
	var cp1 = _cube(p1)
	var cp2 = _cube(p2)
	return max(abs(cp1.x-cp2.x),abs(cp1.y-cp2.y),abs(cp1.z-cp2.z))